# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{json-schema-validator}
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Oleg Keene"]
  s.date = %q{2010-09-30}
  s.description = %q{FIX (describe your package)}
  s.email = ["ol.keene@gmail.com"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "PostInstall.txt"]
  s.files = ["History.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc", "Rakefile", "lib/json-schema-validator.rb", "test/test_helper.rb", "test/test_json-schema-validator.rb"]
  s.homepage = %q{http://github.com/pederbl/json-schema-validator}
  s.post_install_message = %q{PostInstall.txt}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{json-schema-validator}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{FIX (describe your package)}
  s.test_files = ["test/test_helper.rb", "test/test_json-schema-validator.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rubyforge>, [">= 2.0.4"])
      s.add_development_dependency(%q<hoe>, [">= 2.6.2"])
    else
      s.add_dependency(%q<rubyforge>, [">= 2.0.4"])
      s.add_dependency(%q<hoe>, [">= 2.6.2"])
    end
  else
    s.add_dependency(%q<rubyforge>, [">= 2.0.4"])
    s.add_dependency(%q<hoe>, [">= 2.6.2"])
  end
end
