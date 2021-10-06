# frozen_string_literal: true

module Nazar
  class CellFormatter
    def initialize(value, type: :string)
      @value = value
      @type = type
    end

    def format
      case type
      when :boolean
        format_boolean
      when :integer
        format_number
      else
        value.nil? ? format_nil : inteligent_format
      end
    end

    private

    attr_reader :value, :type

    def format_boolean
      return format_nil if value.nil?

      true_value, false_value = Nazar.config.formatter.boolean
      Formatter::TRUTHY_VALUES.include?(value.to_s.downcase) ? true_value : false_value
    end

    def format_nil
      pastel.dim(Nazar.config.formatter.nil)
    end

    def format_number
      pastel.bright_blue(value)
    end

    def inteligent_format
      case value
      when Symbol
        pastel.magenta(":#{value}")
      when Numeric
        format_number
      else
        value.to_s
      end
    end

    def pastel
      @pastel ||= Pastel.new(enabled: Nazar.config.colors.enabled)
    end
  end
end
