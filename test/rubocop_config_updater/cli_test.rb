# frozen_string_literal: true

require 'test_helper'
require 'tempfile'

module RuboCopConfigUpdater
  class CLITest < Minitest::Test
    def setup
      @cli = RuboCopConfigUpdater::CLI.new
    end

    def test_version_command
      assert_output("0.1.0\n") { @cli.run(['--version']) }
    end

    def test_no_error_information
      expected_output = <<~OUTPUT
        Didn't detect any errors with the following configuration:
        RuboCop command: ./test/test_rubocop nothing
        RuboCop config path: .rubocop.yml
      OUTPUT

      assert_output(expected_output) do
        assert_raises SystemExit do
          @cli.run(['--rubocop=./test/test_rubocop nothing'])
        end
      end
    end

    def test_unknown_errors
      expected_output = <<~OUTPUT
        Don't know how to fix received errors with the following configuration:
        RuboCop command: ./test/test_rubocop unknown_error
        RuboCop config path: .rubocop.yml
        Errors:
        unknown_error
      OUTPUT

      assert_output(expected_output) do
        assert_raises SystemExit do
          @cli.run(['--rubocop=./test/test_rubocop unknown_error'])
        end
      end
    end

    def test_fixes_cops
      stderr = <<~STDERR
        .rubocop.yml: Style/VariableName has the wrong namespace - should be Naming
        Error: The `Lint/EndInMethod` cop has been renamed to `Style/EndBlock`.
        (obsolete configuration found in .rubocop.yml, please update it)
        obsolete parameter NameWhitelist (for Naming/PredicateName) found in .rubocop.yml
        `NameWhitelist` has been renamed to `AllowedMethods`.
        obsolete `EnforcedStyle: rails` (for Layout/IndentationConsistency) found in .rubocop.yml
        `EnforcedStyle: rails` has been renamed to `EnforcedStyle: indented_internal_methods`
      STDERR

      old_config = <<~CONFIG
        Layout/IndentationConsistency:
          EnforcedStyle: rails
        Naming/PredicateName:
          NameWhitelist: []
        Lint/InvalidCharacterLiteral:
          Enabled: true
        Layout/SpaceAfterControlKeyword:
          Enabled: true
      CONFIG

      expected_config = <<~CONFIG
        Layout/IndentationConsistency:
          EnforcedStyle: indented_internal_methods
        Naming/PredicateName:
          AllowedMethods: []
        Lint/InvalidCharacterLiteral:
          Enabled: true
        Layout/SpaceAfterControlKeyword:
          Enabled: true
      CONFIG

      expected_output = <<~OUTPUT
        Following changes were applied to configuration file:
          - Style/VariableName replaced with Naming/VariableName
          - Lint/EndInMethod replaced with Style/EndBlock
          - NameWhitelist replaced with AllowedMethods
          - EnforcedStyle: rails replaced with EnforcedStyle: indented_internal_methods

        Following errors weren't fixed:
          - obsolete parameter NameWhitelist (for Naming/PredicateName) found in .rubocop.yml
          - obsolete `EnforcedStyle: rails` (for Layout/IndentationConsistency) found in .rubocop.yml
      OUTPUT

      Tempfile.create('.rubocop-test.yml') do |file|
        file.write(old_config)
        file.rewind

        assert_output(expected_output) do
          @cli.run([
                     "-c#{file.path}",
                     "--rubocop=./test/test_rubocop '#{stderr}'"
                   ])
        end
        assert_equal expected_config, file.read
      end
    end
  end
end
