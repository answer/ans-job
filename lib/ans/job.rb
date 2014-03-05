require "ans/job/version"

module Ans
  module Job
    include ActiveSupport::Configurable

    configure do |config|
      config.lock_namespace = ""
    end

    def self.included(mod)
      require "resque/status"
      require "redis/objects"

      mod.send :include, ::Resque::Plugins::Status
    end

    def perform(*args)
      if respond_to?(:perform_without_lock)
        perform_without_lock(*args)
      else
        Redis::Lock.new(lock_key, timeout: lock_timeout).lock do
          perform_with_lock(*args)
        end
      end
    end

    def on_success
      if respond_to?(:remove_on_success?) && remove_on_success?
        ::Resque::Plugins::Status::Hash.remove(uuid)
      end
    end

    private

    def lock_key
      suffix = lock_key_suffix if respond_to?(:lock_key_suffix)
      "#{Ans::Job.config.lock_namespace}#{self.class.to_s}#{suffix}"
    end
    def lock_timeout
      0.1
    end
  end
end
