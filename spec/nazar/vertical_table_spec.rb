# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Nazar::VerticalTable do
  before do
    Nazar.config.formatter.resize = false
    @colors_before = Nazar.config.colors.enabled
    Nazar.config.colors.enabled = false
  end

  after do
    Nazar.config.colors.enabled = @colors_before
  end

  subject { described_class.new(headers, cells) }
  let(:headers) { ['Id', 'Name', 'Age'] }
  let(:cells) { [[1, 'John', 27], [2, 'Jane', 35]] }
  let(:line) { "────────────\n" }

  describe '#render' do
    it 'renders data vertically' do
      table = subject.render.gsub(/[ \t]+$/, '') # Remove trailing whitespaces
      expect(table).to eq(<<~TABLE.chomp)
        ────────────
        Id   1
        ────────────
        Name John
        Age  27
        ────────────
        Id   2
        ────────────
        Name Jane
        Age  35
        ────────────
      TABLE
    end
  end
end
