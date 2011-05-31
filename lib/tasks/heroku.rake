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
      if working_tree_dirty?
        message 'Please clean your dirty tree!'; exit
      end

      if pull_translations?
        message 'Pulling translations..'
        Rake::Task['trans:fetch:all'].execute

        if working_tree_dirty?
          message 'Please commit the pulled translations!'; exit
        end
      end
      
      if run_juicer?
        message 'Juicing CSS and JavaScript..'
        Rake::Task['deploy:juice'].execute

        if working_tree_dirty?
          message 'Please commit the juiced assets!'; exit
        end
      end
      
      push_to('production')
      migrate_database_of_app(RAILS_APP)
      open_app(RAILS_APP)
    end
  end
  
  desc 'Deploy the hotfix branch'
  task :hotfix do
    if working_tree_dirty?
      message 'Please clean your dirty tree!'
    else
      message 'Pushing hotfix branch to production/master..'
      `git push production hotfix:master`
    end
  end
  
  desc 'Create the hotfix branch'
  task :create_hotfix do
    if working_tree_dirty?
      message 'Please clean your dirty tree!'
    else
      message 'Creating the branch hotfix from production/master..'
      `git checkout -b hotfix production/master`
    end
  end

  desc 'Remove the hotfix branch'
  task :remove_hotfix do
    message 'Deleting the hotfix branch..'
    `git checkout master`
    `git branch -d hotfix`
  end
  
  desc 'Generate minified CSS and JavaScript files'
  task :juice do
    # css
    options = '--force --document-root public/'
    puts `cd #{Rails.root} && juicer merge #{options} public/stylesheets/application.css`

    # js
    options = '--force -i -s -m closure_compiler --document-root public/'
    puts `cd #{Rails.root} && juicer merge #{options} public/javascripts/application.js`
  end
  
  def working_tree_dirty?
    `cd #{Rails.root} && git status --short -uno`.present?
  end
  
  def pull_translations?
    Rake::Task['trans:fetch:all'].present?
  end
  
  def run_juicer?
    `which juicer`.present?
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
