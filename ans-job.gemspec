# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ans/job/version'

Gem::Specification.new do |spec|
  spec.name          = "ans-job"
  spec.version       = Ans::Job::VERSION
  spec.authors       = ["sakai shunsuke"]
  spec.email         = ["sakai@ans-web.co.jp"]
  spec.description   = %q{resque 用 job の基底クラスに include する}
  spec.summary       = %q{job 基本メソッドを提供}
  spec.homepage      = "job 基本メソッドを提供:://github.com/answer/ans-job"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
