# frozen_string_literal: true

module RuboCopConfigUpdater
  class CLI
    class Command
      class FixOutdatedCops < Base
        # Error: The `Layout/AlignArray` cop has been renamed to `Layout/ArrayAlignment`.
        COP_RENAMED_REGEXP = /cop has been renamed to/im.freeze

        # `EnforcedStyle: rails` has been renamed to `EnforcedStyle: indented_internal_methods`
        PROPERTY_RENAMED_REGEXP = /has been renamed to/im.freeze

        # .rubocop.yml: Metrics/LineLength has the wrong namespace - should be Layout
        WRONG_NAMESPACE_REGEXP = /has the wrong namespace/im.freeze

        # .rubocop.yml: Warning: no department given for AccessModifierIndentation.
        NO_DEPARTMENT_REGEXP = /no department given for/im.freeze

        self.command_name = :fix_outdated_cops

        def self.fixes_error?(stderr)
          [
            COP_RENAMED_REGEXP,
            PROPERTY_RENAMED_REGEXP,
            WRONG_NAMESPACE_REGEXP,
            NO_DEPARTMENT_REGEXP
          ].any? { |regexp| regexp.match(stderr) }
        end

        def run
          @errors = []
          @unknown_errors = []

          collect_errors
          fix_errors

          log_changes
        end

        private

        attr_reader :errors, :unknown_errors

        def collect_errors
          stderr.each_line do |line|
            if COP_RENAMED_REGEXP.match?(line)
              matched = line.scan(%r{`(\w+/\w+)`})

              errors << [matched[0], matched[1]].flatten
            elsif PROPERTY_RENAMED_REGEXP.match?(line)
              matched = line.scan(/`(\w+:?\s?\w+)`/)

              errors << [matched[0], matched[1]].flatten
            elsif WRONG_NAMESPACE_REGEXP.match?(line)
              to_replace = line.scan(%r{\w+/\w+}).first
              replace_with = "#{line.split.last}/#{to_replace.split('/').last}"

              errors << [to_replace, replace_with]
            elsif NO_DEPARTMENT_REGEXP.match?(line)
              to_replace = line.split.last.chop
              replace_with = all_cops.grep(%r{/#{to_replace}:}).first.strip.chop

              errors << [to_replace, replace_with]
            else
              unknown_errors << line
            end
          end
        end

        def fix_errors
          rubocop_config = File.read(options[:config_path])

          errors.each do |array|
            rubocop_config.gsub!(array[0], array[1])
          end

          File.write(options[:config_path], rubocop_config)
        end

        # Style/ZeroLengthPredicate:
        #   Description: 'Use #empty? when testing for objects of length 0.'
        #   Enabled: true
        #   Safe: false
        #   VersionAdded: '0.37'
        #   VersionChanged: '0.39'
        def all_cops
          @all_cops ||= `#{options[:cmd]} --show-cops --force-default-config`.lines.select { |l| l.match(/^\w/) }
        end

        def log_changes
          if errors.any?
            puts 'Following changes were applied to configuration file:'

            errors.each do |array|
              puts "  - #{array[0]} replaced with #{array[1]}"
            end
          end

          return unless unknown_errors.any?

          puts
          puts "Following errors weren't fixed:"

          unknown_errors.each do |e|
            # doesn't print an insignificant line
            next if /please update it/.match?(e)

            puts "  - #{e}"
          end
        end
      end
    end
  end
end
