# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aliyun/odps/version'

Gem::Specification.new do |spec|
  spec.name          = "aliyun-odps"
  spec.version       = Aliyun::Odps::VERSION
  spec.authors       = ["Newell Zhu"]
  spec.email         = ["zlx.star@gmail.com"]

  spec.summary       = %q{It is a full-featured Ruby Library for Aliyun ODPS API. Enjoy it!}
  spec.description   = %q{It is a full-featured Ruby Library for Aliyun ODPS API. Enjoy it!}
  spec.homepage      = "https://github.com/aliyun-beta"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
end
