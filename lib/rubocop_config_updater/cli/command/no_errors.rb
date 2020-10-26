# frozen_string_literal: true

module RuboCopConfigUpdater
  class CLI
    class Command
      class NoErrors < Base
        self.command_name = :no_errors

        def self.fixes_error?(stderr)
          # raise stderr.length.to_s
          stderr.to_s.strip.length.zero?
        end

        def run
          puts "Didn't detect any errors with the following configuration:"
          puts "RuboCop command: #{options[:cmd]}"
          puts "RuboCop config path: #{options[:config_path]}"
          exit
        end
      end
    end
  end
end
