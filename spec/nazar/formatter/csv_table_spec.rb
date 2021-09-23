# frozen_string_literal: true

require 'spec_helper'

Nazar.load_csv!

RSpec.describe Nazar::Formatter::CSVTable do
  after(:all) do
    unload_csv!
  end

  subject { described_class.new(collection) }

  let(:collection) { CSV.parse(data, headers: :first_row) }
  let(:data) { [headers, john, jane].join("\n") }
  let(:headers) { ['id', 'name', 'active'].join(',') }
  let(:john) { ['1', 'John Doe', true].join(',') }
  let(:jane) { ['2', 'Jane Doe', false].join(',') }

  context 'with valid data' do
    it do
      expect(subject.valid?).to eq(true)
    end

    it 'formats headers' do
      expect(subject.headers).to have_decorated_content(text: ['id', 'name', 'active'], decorations: { style: :bold })
    end

    it 'converts cells' do
      expect(subject.cells.size).to eq(2)

      expect(subject.cells[0]).to have_decorated_content(text: ['1', 'John Doe', '✓'])
      expect(subject.cells[1]).to have_decorated_content(text: ['2', 'Jane Doe', '✗'])
    end

    it 'counts items' do
      expect(subject.summary).to eq(2)
    end
  end

  context 'with empty collection' do
    let(:data) { '' }

    it do
      expect(subject.valid?).to eq(false)
    end

    it 'does not format headers' do
      expect(subject.headers).to eq([])
    end
  end
end
