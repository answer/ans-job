# Ans::Job

job の基本メソッドを提供

resque 用 job クラスの基底クラスに include する

resque-status も include される

resque 2.0 には対応していない

Redis::Lock により、ロックしつつメソッドを呼び出す

## Installation

Add this line to your application's Gemfile:

    gem 'ans-job'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ans-job

## Usage

    # config/initializers/resque-status.rb
    require "resque/status"
    Resque::Plugins::Status::Hash.expire_in = 24.hours # 24hrs in seconds

    # app/jobs/application_job.rb
    class ApplicationJob
      include Ans::Job

      def on_failure(e)
        puts e.message

        # 実際はメールを送信、等の処理を行う
        #ExceptionNotifier::Notifier.background_exception_notification(e).deliver
      end
    end

    class MyJob < ApplicationJob
      def perform_with_lock
        total = 10
        total.times do |current|
          # resque-status の進捗設定メソッド
          at current, total, "progress: #{current}/#{total}"
        end
        raise "runtime error" # => 例外は on_failure で処理
      end
    end

    class MyJobNoLock < ApplicationJob
      def perform_without_lock
        raise "runtime error"
      end
    end

    MyJob.perform # => puts "runtime error"
    MyJobNoLock.perform # => puts "runtime error"


resque-status の進捗メソッドを使用すると、 resque 管理画面でパーセント表示が進む  
呼び出さなくても完了したかどうかはわかるので、パーセント表示が見たい場合以外はやらなくても問題ない


## Spec

* Ans::Job を include すると、 Resque::Plugins::Status が include される
* `initialize`, `perform`, `on_success`, `self.perform` メソッドは定義しないように
* `perform_with_lock` メソッドを定義するとロックしつつ作業を行う  
  タイムアウト秒は `lock_timeout` メソッドを定義することでオーバーライドできる
* ロックを望まない場合、 `perform_without_lock` メソッドを定義する  
  `perform_with_lock` と `perform_without_lock` の両方を定義した場合、 `perform_without_lock` が優先され、 `perform_with_lock` は呼び出されない
* `remove_on_success?` が true を返す場合、完了時にステータスが削除される

## Setting

    class MyJob < ApplicationJob
      def lock_timeout
        0.1 # Redis::Lock のタイムアウト秒
      end
      def remove_on_success?
        false # 成功時にステータスを削除する場合は true を返す
      end
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
