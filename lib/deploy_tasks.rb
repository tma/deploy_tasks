module DeployTasks
  VERSION = "0.1.0"
  
  class Base < Rails::Railtie
    rake_tasks do
      Dir[File.join(File.dirname(__FILE__), 'tasks/*.rake')].each { |f| load f }
    end
  end
end
