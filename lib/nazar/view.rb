# frozen_string_literal: true

module Nazar
  class View
    extend Forwardable

    def_delegators :formatter, :headers, :cells, :summary

    def initialize(data)
      @data = data
    end

    def render
      return unless supported_data?

      table.tap do
        add_summary if summary
      end
    end

    def supported_data?
      !!formatter_klass && formatter.valid?
    end

    private

    attr_reader :data

    def formatter_klass
      @formatter_klass ||= case data
      when boolean?
        nil
      when acttive_record_collection?
        Formatter::ActiveRecordCollection
      when active_record_item?
        Formatter::ActiveRecordItem
      when csv_table?
        Formatter::CSVTable
      end
    end

    def formatter
      @formatter ||= formatter_klass.new(data)
    end

    def boolean?
      proc { data === true || data === false } # rubocop:disable Style/CaseEquality
    end

    def acttive_record_collection?
      return false unless Nazar.extensions.include?(:active_record)

      proc do
        data.is_a?(ActiveRecord::Associations::CollectionProxy) ||
          data.is_a?(ActiveRecord::Relation) ||
          (data.is_a?(Array) && data.first.is_a?(ActiveRecord::Base))
      end
    end

    def active_record_item?
      return false unless Nazar.extensions.include?(:active_record)

      proc { data.is_a?(ActiveRecord::Base) }
    end

    def csv_table?
      return false unless Nazar.extensions.include?(:csv)

      proc { data.is_a?(CSV::Table) }
    end

    def add_summary
      table.add_separator
      table.add_row [pastel.bold('Total'), { value: summary, colspan: headers.size - 1 }]
    end

    def table
      @table ||= Terminal::Table.new(
        headings: headers,
        rows: cells,
        style: { border: :unicode_thick_edge }
      )
    end

    def pastel
      @pastel ||= Pastel.new(enabled: Nazar.config.colors.enabled)
    end
  end
end
