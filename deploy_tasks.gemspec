# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "deploy_tasks/version"

Gem::Specification.new do |s|
  s.name        = "deploy_tasks"
  s.version     = DeployTasks::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Thomas Maurer"]
  s.email       = ["tma@freshbit.ch"]
  s.homepage    = ""
  s.summary     = %q{Common deploy tasks}
  s.description = %q{Common deploy tasks}

  s.rubyforge_project = "deploy_tasks"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
