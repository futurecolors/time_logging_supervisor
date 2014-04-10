class TimeLogMailer < Mailer

  def time_log_report(to, hours_data)
    @users = []
    hours_data.each do |user, hours|
      url = url_for(:controller => 'timelog', :action => 'index')
      query = "?f[]=spent_on&op[spent_on]=%3D&v[spent_on][]=#{Date.yesterday}&f[]=user_id&op[user_id]=%3D&v[user_id][]=#{user.id}"
      @users << [user, hours, url + query]
    end
    mail(to: to, subject: 'Time logging report')
  end
end
