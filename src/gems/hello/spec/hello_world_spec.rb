# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hello do
  describe ".hello_world" do
    it 'returns "Hello, world!"' do
      expect(Hello.hello_world).to eq("Hello, world!")
    end
  end
end
