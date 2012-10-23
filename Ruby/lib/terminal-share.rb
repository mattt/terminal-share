require 'shellwords'

module TerminalShare
  VERSION = '0.0.1'

  BIN_PATH = File.expand_path('bin/terminal-share')

  class TerminalShareUnavailableException < Exception; end

  class << self
    def available?
      @available ||= `uname`.strip == 'Darwin' && `sw_vers -productVersion`.strip >= '10.8'
    end

    def share(service, items = {})
      raise TerminalShareUnavailableException unless available?

      arguments = [BIN_PATH, "-service #{service}"]
      [:text, :image, :video, :url].each do |type|
        arguments << %{-#{type} "#{items[type]}"} if items[type]
      end

      command = Shellwords.shelljoin(arguments)

      system command
    end
  end
end
