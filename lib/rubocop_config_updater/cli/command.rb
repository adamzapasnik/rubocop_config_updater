# frozen_string_literal: true

module RuboCopConfigUpdater
  class CLI
    class Command
      def initialize(options)
        @options = options
      end

      def run(name)
        class_for(name).new(@options).run
      end

      def fix_errors(stderr)
        class_for_errors(stderr).new(@options, stderr).run
      end

      private

      def class_for(name)
        Base.by_command_name(name)
      end

      def class_for_errors(stderr)
        Base.by_errors(stderr) || UnknownError
      end
    end
  end
end
