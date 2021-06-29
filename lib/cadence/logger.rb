require 'logger'
require 'oj'

module Cadence
  class Logger < ::Logger
    SEVERITIES = %i[debug info warn error fatal unknown].freeze

    SEVERITIES.each do |severity|
      define_method(severity) do |message, details = {}|
        super("#{message} #{format_details(details)}")
      end
    end

    def log(severity, message, details = {})
      add(severity, "#{message} #{format_details(details)}")
    end

    private

    def format_details(details)
      return '' if details.empty?

      Oj.dump(details, mode: :strict)
    end
  end
end
