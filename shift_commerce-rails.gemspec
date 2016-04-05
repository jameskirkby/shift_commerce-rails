# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shift_commerce/rails/version'

Gem::Specification.new do |spec|
  spec.name          = "shift_commerce-rails"
  spec.version       = ShiftCommerce::Rails::VERSION
  spec.authors       = ["Gary Taylor"]
  spec.email         = ["gary.taylor@hismessages.com"]

  spec.summary       = "Rails assistance for shift commerce"
  spec.description   = "Rails assistance for shift commerce"
  spec.homepage      = "http://wehaventgotoneyet.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.test_files = Dir["spec/**/*"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec-rails", "~> 3.3"
  spec.add_runtime_dependency "activemerchant", "~> 1.54"
  spec.add_runtime_dependency "flex_commerce_api"
  spec.add_runtime_dependency "shift_commerce-ui_payment_gateway"
  spec.add_runtime_dependency "shift_commerce-secure_trading"
end
