$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "spina/pos/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "spina-pos"
  spec.version     = Spina::Pos::VERSION
  spec.authors     = ["Bram Jetten"]
  spec.email       = ["mail@bramjetten.nl"]
  spec.homepage    = "https://www.spinacms.com"
  spec.summary     = "Spina POS"
  spec.description = "Spina Shop plugin for iOS-powered Point of Sale system"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails"
  spec.add_dependency "spina"
  spec.add_dependency "pg"
end
