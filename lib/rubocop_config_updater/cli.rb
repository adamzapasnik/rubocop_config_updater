# frozen_string_literal: true

require 'optparse'

module RuboCopConfigUpdater
  class CLI
    DEFAULT_OPTIONS = {
      config_path: '.rubocop.yml',
      cmd: 'bundle exec rubocop'
    }.freeze

    attr_accessor :options

    def initialize
      @options = DEFAULT_OPTIONS.dup
    end

    def run(args = ARGV)
      parse_options(args)

      command = RuboCopConfigUpdater::CLI::Command.new(@options)

      return command.run(:version) if options[:version]

      unless File.exist?(options[:config_path])
        warn "File #{options[:config_path]} doesn't exist"
        exit(1)
      end

      # a little hack to minimalize operation time and stdout length
      stderr = `#{options[:cmd]} -L Gemfile 2>&1 >/dev/null`

      command.fix_errors(stderr)
    end

    private

    def parse_options(args)
      OptionParser.new do |opts|
        opts.banner = 'Usage: rubocop_config_updater [options]'

        opts.on('-c', '--config PATH', 'Rubocop config path, i.e. .rubocop.yml') do |v|
          options[:config_path] = v
        end

        opts.on('-r', '--rubocop COMMAND', 'Rubocop command, i.e. bundle exec rubocop') do |v|
          options[:cmd] = v
        end

        opts.on('-v', '--version') do |v|
          options[:version] = v
        end
      end.parse!(args)
    end
  end
end
