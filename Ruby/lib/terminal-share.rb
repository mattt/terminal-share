require 'shellwords'

module TerminalShare
  VERSION = '0.1.2'

  class TerminalShareUnavailableException < Exception; end

  class << self
    def available?
      @available ||= `uname`.strip == 'Darwin' && `sw_vers -productVersion`.strip >= '10.8' && !`which terminal-share`.empty?
    end

    def share(service, items = {})
      raise TerminalShareUnavailableException unless available?

      arguments = ["-service #{service}"]
      [:text, :image, :video, :url].each do |type|
        arguments << %{-#{type} "#{items[type]}"} if items[type]
      end

      command = "terminal-share #{Shellwords.shelljoin(arguments)}"

      system command
    end
  end
end
