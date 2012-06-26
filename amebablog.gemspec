# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "amebablog/version"

Gem::Specification.new do |s|
  s.name        = "amebablog"
  s.version     = Amebablog::VERSION
  s.authors     = ["nacy0708"]
  s.email       = ["wise.clerk@gmail.com"]
  s.homepage    = "https://github.com/nacy0708/amebablog"
  s.summary     = %q{アメーバブログへの記事投稿・編集・削除・取得を行う}
  s.description = %q{アメーバブログへの記事投稿・編集・削除・取得を行う}

  s.rubyforge_project = "amebablog"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
  s.add_dependency "nokogiri"
end
