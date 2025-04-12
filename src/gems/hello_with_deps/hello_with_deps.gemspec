Gem::Specification.new do |spec|
  spec.name = "hello_with_deps"
  spec.version = "0.1.0"
  spec.summary = "hello with deps"
  spec.authors = ["Your Name"]
  spec.files = Dir["lib/**/*.rb"]
  spec.require_paths = ["lib"]
  spec.add_dependency "awesome_print", "~> 1.9.2"
end
