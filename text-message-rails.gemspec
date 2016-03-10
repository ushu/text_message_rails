# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'text_message_rails/version'

Gem::Specification.new do |spec|
  spec.name          = "text-message-rails"
  spec.version       = TextMessage::VERSION
  spec.authors       = ["Aurélien Noce"]
  spec.email         = ["aurelien.noce@imagine-app.fr"]

  spec.summary       = %q{Easy text messaging from Rails.}
  spec.description   = %q{
    Simple ActionMail-like Text Message controllers for Rails 3+.
    (this is a *very* early version !)
  }
  spec.homepage      = "http://github.com/ushu/text-message-rails"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_dependency "rails", "> 3.0"
end
