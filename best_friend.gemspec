require_relative 'lib/best_friend/version'

Gem::Specification.new do |spec|
  spec.name          = "best_friend"
  spec.version       = BestFriend::VERSION
  spec.authors       = ["reddevilcero"]
  spec.email         = ["reddevil_cero@hotmail.com"]

  spec.summary       = "Cli gem to find or know, about more  your best friend"
  spec.homepage      = "https://github.com/reddevilcero/Best_Friend"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org/"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/reddevilcero/Best_Friend"
  spec.metadata["changelog_uri"] = "https://github.com/reddevilcero/Best_Friend"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
