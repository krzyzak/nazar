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
        format_boolean(value)
      when :integer
        Pastel.new.bright_blue(value)
      else
        value.nil? ? format_nil : value.to_s
      end
    end

    private

    attr_reader :value, :type

    def format_boolean(value)
      return format_nil if value.nil?

      true_value, false_value = Nazar.config.formatter.boolean
      Formatter::TRUTHY_VALUES.include?(value.to_s.downcase) ? true_value : false_value
    end

    def format_nil
      Pastel.new.dim(Nazar.config.formatter.nil)
    end
  end
end
