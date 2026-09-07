# typed: strict
# frozen_string_literal: true

RSpec.describe "brew formulae", type: :system do
  # `brew_sh` runs the real `brew.sh` against the developer's own
  # `HOMEBREW_REPOSITORY/Library/Taps`, so the tap trust path warns on stderr for
  # every untrusted tap, and again when `jq` is unavailable.
  it "prints all installed Formulae", :integration_test do
    expect { brew_sh "formulae", "HOMEBREW_NO_REQUIRE_TAP_TRUST" => "1" }
      .to be_a_success
      .and not_to_output.to_stderr
  end
end
