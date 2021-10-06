# frozen_string_literal: true

require 'spec_helper'
require 'sequel_helper'

Nazar.load_sequel!

RSpec.describe Nazar::Formatter::SequelCollection do
  subject(:validator) { described_class.valid?(collection) }
  subject { described_class.new(collection) }

  let!(:john) { SequelUser.create(name: 'John Doe', active: true) }
  let!(:jane) { SequelUser.create(name: 'Jane Doe', active: false) }

  after(:each) do
    DB[:users].delete
  end

  after(:all) do
    unload_sequel!
  end

  shared_examples 'handles collection' do
    it do
      expect(validator).to eq(true)
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

  context 'with Array of items' do
    let(:collection) { SequelUser.all }

    it_behaves_like 'handles collection'
  end

  context 'with Set of items' do
    let(:collection) { SequelUser.all.to_set }

    it_behaves_like 'handles collection'
  end

  context 'with empty collection' do
    let(:collection) { SequelUser.where(name: 'John Cena') }

    it do
      expect(validator).to eq(true)
      expect(subject.valid?).to eq(false)
    end
  end
end
