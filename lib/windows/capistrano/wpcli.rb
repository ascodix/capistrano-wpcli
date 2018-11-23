require "windows/capistrano/wpcli/version"

module Windows
  module Capistrano
    module Wpcli
      files = Dir[File.join(File.dirname(__FILE__), 'tasks', '*.rake')]
      files.each do |file|
        load file
      end
    end
  end
end
