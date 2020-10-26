# frozen_string_literal: true

module RuboCopConfigUpdater
  class CLI
    class Command
      class Version < Base
        self.command_name = :version

        def run
          puts RuboCopConfigUpdater::VERSION
        end
      end
    end
  end
end
