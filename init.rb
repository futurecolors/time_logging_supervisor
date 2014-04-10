Redmine::Plugin.register :time_logging_supervisor do
  name 'Time Logging Supervisor plugin'
  author 'Sergey Morozov'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  settings :default => {}, :partial => 'time_logging_supervisor/settings'
end
