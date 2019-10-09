# frozen_string_literal: true

require 'yaml'
require 'active_support/core_ext/hash/indifferent_access'

module Nexoform
  class Config
    def self.has_config_file?(dir)
      File.exist?("#{dir}/nexoform.yml")
    end

    def self.find_config_file(starting_dir)
      if has_config_file?(starting_dir)
        "#{starting_dir}/nexoform.yml"
      elsif starting_dir == '/'
        default_filename
      else
        find_config_file(File.dirname(starting_dir)) # recurse up to /
      end
    end

    def self.default_filename
      './nexoform.yml'
    end

    def self.filename
      find_config_file(Dir.pwd)
    end

    def self.proj_name(project_name)
      project_name && !project_name.empty? ? project_name : '<companyname>'
    end

    def self.default_yaml(project_name)
      %(---
        nexoform:
          environments:
            default: dev          # optional default env so you don't have to specify
            dev:                  # name of environment
              varFile: dev.tfvars # terraform var-file to use
              plan:               # optional block. Avoids getting prompted
                enabled: yes      # yes | no.  If no, a plan file is not used
                file: dev.tfplan  # file the plan is saved to automatically
                overwrite: yes    # overwrite existing file. could be: yes | no | ask
              state:              # configuration for state management s3 backend
                region: us-east-1 # Region where the BUCKET specified here lives, not the region you are provisioning to
                bucket: #{project_name}-terraform-state
                key: dev.tfstate
            staging:                  # name of environment
              varFile: staging.tfvars # terraform var-file to use
              plan:                   # optional block. Avoids getting prompted
                enabled: yes          # yes | no.  If no, a plan file is not used
                file: staging.tfplan  # file the plan is saved to automatically
                overwrite: yes        # overwrite existing file. could be: yes | no | ask
              state:                  # configuration for state management s3 backend
                region: us-east-1     # Region where the BUCKET specified here lives, not the region you are provisioning to
                bucket: #{project_name}-terraform-state
                key: staging.tfstate
            prod:                  # name of environment
              varFile: prod.tfvars # terraform var-file to use
              plan:                # optional block. Avoids getting prompted
                enabled: yes       # yes | no.  If no, a plan file is not used
                file: prod.tfplan  # file the plan is saved to automatically
                overwrite: yes     # overwrite existing file. could be: yes | no | ask
              state:               # configuration for state management s3 backend
                region: us-east-1  # Region where the BUCKET specified here lives, not the region you are provisioning to
                bucket: #{project_name}-terraform-state
                key: prod.tfstate
      ).split("\n").map { |s| s.sub(' ' * 8, '') }.join("\n")
    end

    def self.default_settings(project_name = nil)
      YAML.safe_load(default_yaml(proj_name(project_name))).with_indifferent_access
    end

    def self.settings(filename = self.filename)
      YAML.load_file(filename).with_indifferent_access if File.exist?(filename)
    end

    def self.write_settings(settings, filename = self.filename, is_yaml: false)
      settings = settings.to_yaml unless is_yaml
      settings.gsub!(/\s*!ruby\/hash:ActiveSupport::HashWithIndifferentAccess/, '')
      File.write(filename, settings)
    end

    def self.write_default_settings_file(project_name = nil)
      write_settings(default_yaml(proj_name(project_name)), filename, is_yaml: true)
    end

    def self.debug?
      settings[:nexoform][:debug]
    end

    def self.envs
      settings[:nexoform][:environments].keys.reject { |k| k == 'default' }
    end

    def self.var_file(environment)
      find_value(%I[nexoform environments #{environment} varFile])
    end

    def self.default_env
      settings[:nexoform][:environments][:default]
    end

    def self.bucket(environment)
      find_value(%I[nexoform environments #{environment} state bucket])
    end

    def self.key(environment)
      find_value(%I[nexoform environments #{environment} state key])
    end

    def self.region(environment)
      find_value(%I[nexoform environments #{environment} state region])
    end

    def self.plan_enabled(environment)
      find_value(%I[nexoform environments #{environment} plan enabled])
    end

    def self.plan_disabled?(environment)
      !plan_enabled(environment)
    rescue ConfigError => e
      false
    end

    def self.plan_file(environment)
      find_value(%I[nexoform environments #{environment} plan file])
    end

    def self.has_plan_file?(environment)
      return false if plan_disabled?(environment)

      plan_file(environment)
    rescue ConfigError => e
      false
    end

    def self.plan_file_overwrite(environment)
      find_value(%I[nexoform environments #{environment} plan overwrite])
    end

    def self.has_plan_file_overwrite?(environment)
      plan_file_overwrite(environment)
      true
    rescue ConfigError => e
      false
    end

    private

    class ConfigError < StandardError
    end

    def self.find_value(keys)
      keys.reduce(settings) do |last_val, key|
        if last_val[key].nil?
          raise ConfigError, "Key '#{key}' in chain '#{keys.join(' -> ')}' produced a " \
            'nil value.  The expected key is missing in your config file.'
        end
        last_val[key]
      end
    end
  end
end
