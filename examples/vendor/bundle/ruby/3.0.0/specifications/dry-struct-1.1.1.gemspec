# -*- encoding: utf-8 -*-
# stub: dry-struct 1.1.1 ruby lib

Gem::Specification.new do |s|
  s.name = "dry-struct".freeze
  s.version = "1.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "allowed_push_host" => "https://rubygems.org", "changelog_uri" => "https://github.com/dry-rb/dry-struct/blob/master/CHANGELOG.md", "source_code_uri" => "https://github.com/dry-rb/dry-struct" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Piotr Solnica".freeze]
  s.bindir = "exe".freeze
  s.date = "2019-10-13"
  s.description = "Typed structs and value objects.".freeze
  s.email = ["piotr.solnica@gmail.com".freeze]
  s.homepage = "https://github.com/dry-rb/dry-struct".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.4.0".freeze)
  s.rubygems_version = "3.2.32".freeze
  s.summary = "Typed structs and value objects.".freeze

  s.installed_by_version = "3.2.32" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<dry-equalizer>.freeze, ["~> 0.2"])
    s.add_runtime_dependency(%q<dry-types>.freeze, ["~> 1.0"])
    s.add_runtime_dependency(%q<dry-core>.freeze, ["~> 0.4", ">= 0.4.3"])
    s.add_runtime_dependency(%q<ice_nine>.freeze, ["~> 0.11"])
    s.add_development_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_development_dependency(%q<rake>.freeze, ["~> 11.0"])
    s.add_development_dependency(%q<rspec>.freeze, ["~> 3.3"])
    s.add_development_dependency(%q<yard>.freeze, ["~> 0.9.5"])
  else
    s.add_dependency(%q<dry-equalizer>.freeze, ["~> 0.2"])
    s.add_dependency(%q<dry-types>.freeze, ["~> 1.0"])
    s.add_dependency(%q<dry-core>.freeze, ["~> 0.4", ">= 0.4.3"])
    s.add_dependency(%q<ice_nine>.freeze, ["~> 0.11"])
    s.add_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, ["~> 11.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.3"])
    s.add_dependency(%q<yard>.freeze, ["~> 0.9.5"])
  end
end
