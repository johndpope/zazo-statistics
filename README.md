Zazo Statistics
===========

[![wercker status](https://app.wercker.com/status/b5619d0cc05abbe5e013a9578fc338f0/m "wercker status")](https://app.wercker.com/project/bykey/b5619d0cc05abbe5e013a9578fc338f0)

Stack:

* **Rails** 4.2
* **Slim** for templates
* **Bootstrap** 3 (SASS) for frontend
* **MySQL** for data storage
* **Twilio** for verification with code
* Generic **GCM server** for Android notifications
* **Houston** for iOS notification
* **Rollbar** for errors
* **wercker** for CI

## Setup

1. Copy and update config with correct values:

        cp config/application.yml.example config/application.yml

2. Prepare database:

        bin/rake db:create db:migrate

3. Then run server:

        bin/rails s

4. To set S3 credentials, go to [s3_credentials](http://localhost:3000/s3_credentials).

## Specs

    bin/rake spec
