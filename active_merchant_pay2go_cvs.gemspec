# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_merchant_pay2go_cvs/version'

Gem::Specification.new do |spec|
  spec.name          = "active_merchant_pay2go_cvs"
  spec.version       = ActiveMerchantPay2goCvs::VERSION
  spec.authors       = ["hrs"]
  spec.email         = ["hrs113355@gmail.com"]
  spec.description   = %q{activermerchant plugin to implement Pay2go CVS gateway}
  spec.summary       = %q{activermerchant plugin to implement Pay2go CVS gateway}
  spec.homepage      = "https://github.com/hrs113355/active_merchant_pay2go_cvs"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'activemerchant', '>= 1.42'
  spec.add_development_dependency('test-unit', '~> 2.5.5')

  spec.add_development_dependency('rake')
  spec.add_development_dependency('mocha', '~> 0.13.0')
  spec.add_development_dependency('rails', '>= 4.2')
  spec.add_development_dependency('thor')
end
