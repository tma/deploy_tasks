Deploy Tasks
============

To tell the tasks what is the name of your application, set a the constant
RAILS_APP like this:

    RAILS_APP = 'my_fabulous_app'

Heroku
------

You get the following rake tasks (run `rake -T` to see the descriptions):

 * deploy:production
 * deploy:staging

 * deploy:create_hotfix
 * deploy:hotfix
 * deploy:remove_hotfix

 * deploy:juice (if you use juicer)

The deploy tasks pull translations from webtranslateit.com if you use it, juice
your assets with juicer and finally deploy, if everything's committed.

License
-------

MIT License - Thomas Maurer
