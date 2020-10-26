# frozen_string_literal: true

module RuboCopConfigUpdater
  class CLI
    class Command
      class UnknownError < Base
        self.command_name = :unknown_error

        def run
          puts "Don't know how to fix received errors with the following configuration:"
          puts "RuboCop command: #{options[:cmd]}"
          puts "RuboCop config path: #{options[:config_path]}"
          puts 'Errors:'
          puts stderr
          # raise "IMHRE"
          exit
        end
      end
    end
  end
end
