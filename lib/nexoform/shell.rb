# frozen_string_literal: true

require 'ostruct'

module Nexoform
  module Sh
    def self.run_command(command, print_stdout = false)
      stdout = `#{command}`
      puts stdout if print_stdout
      OpenStruct.new(
        success?: $?.exitstatus.zero?,
        exitstatus: $?.exitstatus,
        stdout: stdout
      )
    end
  end

  module Bash
    def self.escape_double_quotes(str)
      str.gsub('"', '\\"')
    end

    def self.run_command(command, print_stdout = false)
      stdout = `bash -c "#{escape_double_quotes(command)}"`
      puts stdout if print_stdout
      OpenStruct.new(
        success?: $?.exitstatus.zero?,
        exitstatus: $?.exitstatus,
        stdout: stdout
      )
    end

    def self.run_command_loud(command)
      exitstatus = system("bash -c \"#{escape_double_quotes(command)}\"")
      OpenStruct.new(
        success?: exitstatus,
        exitstatus: exitstatus ? '0' : '1', # we lose the true exit code
        stdout: '' # we lose stdout too
      )
    end
  end
end
