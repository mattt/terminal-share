# frozen_string_literal: true

require 'shellwords'

module TerminalShare
  class UnavailableException < RuntimeError
  end

  class << self
    def share(service, items = {})
      raise UnavailableException unless available?

      arguments = ["-service #{service}"]
      %i[text image video url].each do |type|
        arguments << %(-#{type} "#{items[type]}") if items[type]
      end

      command = "terminal-share #{Shellwords.shelljoin(arguments)}"

      system command
    end

    private

    def available?
      @available ||= `uname`.strip == 'Darwin' && `sw_vers -productVersion`.strip >= '10.8' && !`which terminal-share`.empty?
    end
  end
end
