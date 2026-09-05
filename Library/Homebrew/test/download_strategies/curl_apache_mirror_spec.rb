# typed: true
# frozen_string_literal: true

require "download_strategy"

RSpec.describe CurlApacheMirrorDownloadStrategy do
  subject(:strategy) { described_class.new(url, name, version, **specs) }

  let(:name) { "foo" }
  let(:version) { "1.2.3" }
  let(:specs) { {} }
  let(:url) do
    "https://www.apache.org/dyn/closer.lua?path=foo-1.2.3.tar.gz&token=" \
      "#{EnvSensitive::DEFERRED_PLACEHOLDER_PREFIX}HOMEBREW_PRIVATE_TOKEN" \
      "#{EnvSensitive::DEFERRED_PLACEHOLDER_SUFFIX}"
  end

  describe "#mirrors" do
    before do
      ENV["HOMEBREW_PRIVATE_TOKEN"] = "glpat-secret"
      strategy.allow_deferred_environment_expansion!
    end

    it "expands a deferred secret in the control URL it extends" do
      seen = []
      allow(strategy).to receive(:system_command) do |_command, options|
        seen.concat(options[:args])
        instance_double(
          SystemCommand::Result,
          success?: true,
          stdout:   '{"backup":[],"path_info":"/foo-1.2.3.tar.gz"}',
        )
      end
      strategy.mirrors

      expect(seen).to include(a_string_including("token=glpat-secret&asjson=1"))
    end
  end
end
