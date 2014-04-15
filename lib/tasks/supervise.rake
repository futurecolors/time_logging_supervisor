namespace :redmine do
  task :time_logging_report => :environment do
    settings = Setting.plugin_time_logging_supervisor
    hours_data = TimeEntry.where(spent_on: Date.yesterday).group('user_id').sum('hours')

    min, max = ['min_time', 'max_time'].map {|f| Float(settings[f]) rescue nil}
    hours_data.keep_if {|user_id, hours| (min and hours < min) or (max and hours > max)}

    all_user_ids = Member.joins(:roles).where('roles.id' => settings['roles']).pluck(:user_id).uniq
    hours_data = all_user_ids.inject({}) {|h, v| h.merge({v => 0})}.merge(hours_data)

    if !hours_data.empty? and settings['recipients']
      users = User.active.where(id: hours_data.keys).index_by(&:id)
      Mailer.with_synched_deliveries do
        TimeLogMailer.time_log_report(
          User.where(id: settings['recipients']).pluck(:mail),
          hours_data.map {|user_id, hours| [users[user_id], hours]}.select {|user, hours| user}
        ).deliver
      end
    end
  end
end
