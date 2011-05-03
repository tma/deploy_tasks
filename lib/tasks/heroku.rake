namespace :deploy do
  desc 'Deploy to staging'
  task :staging do
    if Rake::Task['trans:fetch:all'].present?
      message 'Pulling translations..'
      Rake::Task['trans:fetch:all'].execute
    end
    
    if working_tree_dirty?
      message 'Please clean your dirty tree!'; exit
    end

    push_to('staging')
    migrate_database_of_app("#{RAILS_APP}-staging")
    open_app("#{RAILS_APP}-staging")
  end

  desc 'Deploy to production'
  task :production do
    message '>> Are you sure to deploy to production? (type yes): ', true
    if STDIN.gets.chomp == 'yes'
      if Rake::Task['trans:fetch:all'].present?
        message 'Pulling translations..'
        Rake::Task['trans:fetch:all'].execute
      end
      
      if working_tree_dirty?
        message 'Please clean your dirty tree!'; exit
      end
      
      push_to('production')
      migrate_database_of_app('calculate')
      open_app('calculate')
    end
  end
  
  def working_tree_dirty?
    `cd #{Rails.root} && git status --short -uno`.present?
  end

  def push_to(env)
    message "Pushing to #{env}.."
    `cd #{Rails.root} && git push #{env} master`
  end
  
  def migrate_database_of_app(heroku_app)
    message "Migrate the database of #{heroku_app}.."
    `cd #{Rails.root} && heroku rake db:migrate --app #{heroku_app}`
  end
  
  def open_app(heroku_app)
    message 'Opening heroku app..'
    `cd #{Rails.root} && heroku open --app #{heroku_app}`
  end
  
  def message(string, print = false)
    s = "\e[0;33m\033[1m#{string}\e[0m"
    print ? print(s) : puts(s)
  end
end
