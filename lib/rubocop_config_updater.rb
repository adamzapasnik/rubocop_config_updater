# frozen_string_literal: true

require 'rubocop_config_updater/version'

require_relative 'rubocop_config_updater/cli'

require_relative 'rubocop_config_updater/cli/command'
require_relative 'rubocop_config_updater/cli/command/base'
require_relative 'rubocop_config_updater/cli/command/fix_errors'
require_relative 'rubocop_config_updater/cli/command/no_errors'
require_relative 'rubocop_config_updater/cli/command/unknown_error'
require_relative 'rubocop_config_updater/cli/command/version'

module RuboCopConfigUpdater
end
#   class Error < StandardError; end
#   # Your code goes here...
#   def new_cops(file)
#     output = `bundle exec rubocop #{file}`

#   end
#   def clean_dot_rubocop
#     output = `bundle exec rubocop 2>&1`
#     correct_cops = `bundle exec rubocop --show-cops --force-default-config`.lines.select { |l| l.match(/^\w/) }
#     printf output

# matchers = []
# removed = []
# ap correct_cops
# puts "OUTPUT"

# puts output.class
# output.each_line do |line|
#   if /cop has been renamed to/.match?(line)
#     matched = line.scan(/`(\w+\/+\w+)`/)
#   elsif /has been renamed to/.match?(line)
#     matched = line.scan(/`(\w+:\s[\w_]+)`/)
#   elsif /has the wrong namespace -/.match?(line)
#     first_match = line.scan(/\w+\/\w+/).first
#     second_match = line.split.last + "/" + first_match.split("/").last
#     matchers << [first_match, second_match]
#   elsif /no department given for/.match?(line)
#     first_match = line.split.last.chop
#     # ap first_match
#     second_match = correct_cops.grep(/#{first_match}/).first.trim.chop
#     matchers << [first_match, second_match]
#   elsif /cop has been removed/.match?(line)
#     removed << line.scan(/`(\w+\/+\w+)`/).first
#   end
#   matchers << matched.flatten if matched
# end
# puts "WTF"

# # ap matchers

# # yml = YAML.load_file('.rubocop.yml')
# # puts yml

# rubocop_config = File.read('.rubocop.yml')
# matchers.each do |match|
#   puts match
#   rubocop_config.gsub!(match[0], match[1])
# end

# File.write('.rubocop.yml', rubocop_config)

#   end
# end
