# THE TOURNAMENT #
THE TOURNAMENT is a simple and easy-to-use tournament management system.
Now under SuperBETA.

## Database ##

    % createuser -e -s -d tnmt
    % bundle exec rake db:create
    % bundle exec rake db:migrate


## Test ENV Setting ##

    % psql postgres
    >postgres=# CREATE ROLE tnmt;
    >postgres=# ALTER ROLE tnmt WITH LOGIN;
    >postgres=# ALTER ROLE tnmt WITH CREATEDB;
    % bundle exec rake db:create RAILS_ENV=test
    % bundle exec rake db:migrate RAILS_ENV=test
