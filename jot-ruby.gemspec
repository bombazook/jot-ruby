
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "jot/ruby/version"

Gem::Specification.new do |spec|
  spec.name          = "jot-ruby"
  spec.version       = Jot::Ruby::VERSION
  spec.authors       = ["Kostrov Alexander"]
  spec.email         = ["bombazook@gmail.com"]

  spec.summary       = %q{ruby adapter for JOT OT-library protocol}
  spec.description   = %q{ruby adapter for JOT OT-library protocol. By default original Joshua Tauberer Operational Transform library impl throuugh execjs}
  spec.homepage      = "https://github.com/bombazook/jot-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
