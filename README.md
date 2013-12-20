# Ans::Job

job の基本メソッドを提供

resque 用 job クラスの基底クラスに include する

## Installation

Add this line to your application's Gemfile:

    gem 'ans-job'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ans-job

## Usage

    # app/jobs/application_job.rb
    class ApplicationJob
      include Ans::Job

      def handle_standard_error(e)
        # メールを送信、等
        puts e.message
      end
    end

    class MyJob < ApplicationJob
      def perform
        raise "runtime error"
      end
    end

    MyJob.perform # => puts "runtime error"

`Ans::Job` を `include` したクラスを継承すると、 `self.perform` メソッドが定義される  
`self.perform` メソッドは、 `Redis::Lock` によってロックしつつ、自分を new して `perform` メソッドを呼び出す  
発生した `StandardError` は `self.perform` で `rescue` され、 `handle_standard_error` をコールする

## Setting

    # config/initializers/ans-job.rb
    Ans::Job.configure do |config|
      config.perform_method_name = :perform
      config.handle_standard_error_method_name = :handle_standard_error
    end

    class MyJob < ApplicationJob
      configure do |config|
        config.is_lock = false # Redis::Lock でロックするか？
        config.lock_timeout = 0.5 # Redis::Lock のタイムアウト秒
      end
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
