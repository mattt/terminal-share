module TerminalShare
  VERSION = '0.0.1'

  BIN_PATH = File.expand_path('bin/terminal-share.app/Contents/MacOS/terminal-share')

  class TerminalShareUnavailableException < Exception; end

  class << self
    def available?
      @available ||= `uname`.strip == 'Darwin' && `sw_vers -productVersion`.strip >= '10.8'
    end

    def share(service, items = {})
      raise TerminalShareUnavailableException unless available?

      command, arguments = "", []

      arguments << BIN_PATH
      arguments << "-service #{service}"

      [:text, :image, :video, :url].each do |type|
        arguments << %{-#{type} "#{items[type]}"} if items[type]
      end

      if RUBY_VERSION < '1.9'
        require 'shellwords'
        command = Shellwords.shelljoin(arguments)
      else
        command = arguments.join(" ")
      end

      puts command

      system command
    end
  end
end
