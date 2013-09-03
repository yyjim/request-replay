# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "replay-request"
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Lin Jen-Shin (godfat)"]
  s.date = "2013-09-04"
  s.description = "Replay the request via Rack env"
  s.email = ["godfat (XD) godfat.org"]
  s.files = [
  ".gitmodules",
  "CHANGES.md",
  "LICENSE",
  "README.md",
  "Rakefile",
  "lib/replay-request.rb",
  "lib/replay-request/middleware.rb",
  "replay-request.gemspec",
  "task/.gitignore",
  "task/gemgem.rb",
  "test/test_basic.rb"]
  s.homepage = "https://github.com/godfat/replay-request"
  s.licenses = ["Apache License 2.0"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.7"
  s.summary = "Replay the request via Rack env"
  s.test_files = ["test/test_basic.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bacon>, [">= 0"])
      s.add_development_dependency(%q<rack>, [">= 0"])
    else
      s.add_dependency(%q<bacon>, [">= 0"])
      s.add_dependency(%q<rack>, [">= 0"])
    end
  else
    s.add_dependency(%q<bacon>, [">= 0"])
    s.add_dependency(%q<rack>, [">= 0"])
  end
end
