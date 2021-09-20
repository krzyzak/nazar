# frozen_string_literal: true

require 'spec_helper'
require 'active_record_helper'

RSpec.describe Nazar::Formatter::ActiveRecordCollection do
  subject { described_class.new(collection) }

  let!(:john) { User.create(name: 'John Doe', active: true) }
  let!(:jane) { User.create(name: 'Jane Doe', active: false) }

  after(:each) do
    User.delete_all
  end

  shared_examples 'handles collection' do
    it do
      expect(subject.valid?).to eq(true)
    end

    it 'formats headers' do
      expect(subject.headers).to have_decorated_content(text: ['id', 'name', 'active'], decorations: { style: :bold })
    end

    it 'converts cells' do
      expect(subject.cells.size).to eq(2)

      expect(subject.cells[0]).to have_decorated_content(text: [john.id.to_s, 'John Doe', '✓'])
      expect(subject.cells[1]).to have_decorated_content(text: [jane.id.to_s, 'Jane Doe', '✗'])
    end

    it 'counts items' do
      expect(subject.summary).to eq(2)
    end
  end

  context 'with ActiveRecord collection' do
    let(:collection) { User.all }

    it_behaves_like 'handles collection'
  end

  context 'with array of ActiveRecord items' do
    let(:collection) { User.first(2) }

    it_behaves_like 'handles collection'
  end

  context 'with #none' do
    let(:collection) { User.none }

    it do
      expect(subject.valid?).to eq(false)
    end
  end

  context 'with empty collection' do
    let(:collection) { User.where(name: 'John Cena') }

    it do
      expect(subject.valid?).to eq(false)
    end
  end
end
