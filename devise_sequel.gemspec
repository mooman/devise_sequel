require 'rake'

Gem::Specification.new do |s|
  s.name = "devise_sequel"
  s.version = '0.0.3'
  s.platform = Gem::Platform::RUBY
  s.authors = ["Rachot Moragraan"]
  s.description = "Sequel support for Devise"
  s.summary = "Sequel support for Devise"
  s.email = "janechii@gmail.com"
  s.homepage = "http://github.com/mooman/devise_sequel"

  s.rubyforge_project = "devise_sequel"
  s.required_rubygems_version = ">= 1.3.6"

  s.files = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
  s.has_rdoc = false

  s.add_dependency "orm_adapter-sequel"
  s.add_dependency "devise", '>= 1.2.rc'
  s.add_dependency "sequel"
end
