# frozen_string_literal: true

module RuboCopConfigUpdater
  class CLI
    class Command
      class Base
        attr_reader :env

        @subclasses = []

        class << self
          attr_accessor :command_name

          def inherited(subclass)
            @subclasses << subclass
          end

          def by_command_name(name)
            @subclasses.detect { |s| s.command_name == name }
          end

          def by_errors(stderr)
            @subclasses.detect { |s| s.fixes_error?(stderr) }
          end

          def fixes_error?(_stderr)
            false
          end
        end

        attr_accessor :options, :stderr

        def initialize(options, stderr = '')
          @options = options
          @stderr = stderr
        end
      end
    end
  end
end
