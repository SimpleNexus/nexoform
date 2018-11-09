# frozen_string_literal: true

Gem.find_files('nexoform/**/*.rb').each do |path|
  require path.gsub(/\.rb$/, '') unless path =~ /bot.*cli/
end
