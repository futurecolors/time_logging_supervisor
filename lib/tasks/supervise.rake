namespace :redmine do
  task :time_logging_report => :environment do
    settings = Setting.plugin_time_logging_supervisor
    hours_data = TimeEntry.where(spent_on: Date.yesterday).group('user_id').sum('hours')

    min, max = ['min_time', 'max_time'].map {|f| Float(settings[f]) rescue nil}
    hours_data.keep_if {|user_id, hours| (min and hours < min) or (max and hours > max)}
    users = User.where(id: hours_data.keys).index_by(&:id)

    if !hours_data.empty? and settings['recipients']
      TimeLogMailer.time_log_report(
        User.where(id: settings['recipients']).pluck(:mail),
        hours_data.map {|user_id, hours| [users[user_id], hours]}
      ).deliver
    end
  end
end
