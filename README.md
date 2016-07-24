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

## DNS

PointDNS→CloudFlareに変更。

### ムームードメイン

DNSをCloudFlareのもので設定。

### CloudFlare

- SSLを有効にする
- つねにhttpsを使用
- HSTSを有効化

## Resouceの配置

asset_syncを利用して、GoogleCloudStorageにassetsを配置。  

FontawesomeのCORS問題があるため、cors.jsonを設定して対応。

>https://cloud.google.com/storage/docs/cross-origin

    gsutil cors set cors-json-file.json gs://example
