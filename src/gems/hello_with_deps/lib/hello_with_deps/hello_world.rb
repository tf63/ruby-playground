# frozen_string_literal: true

require "awesome_print"

module HelloWithDeps
  def self.hello_world
    ap "Hello, world!"
  end
end
