# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Nazar::Formatter::Generic do
  subject { described_class.new(collection) }

  let(:struct) { Struct.new(:name, :age) }

  let(:john_hash) { { name: 'John', age: 18 } }
  let(:jane_hash) { { name: 'Jane', age: 25 } }

  let(:john_struct) { struct.new('John', 18) }
  let(:jane_struct) { struct.new('Jane', 25) }

  shared_examples 'handles collection' do
    it do
      expect(subject.valid?).to eq(true)
    end

    it 'formats headers' do
      expect(subject.headers).to have_decorated_content(text: ['name', 'age'], decorations: { style: :bold })
    end

    it 'converts cells' do
      expect(subject.cells.size).to eq(2)

      expect(subject.cells[0]).to have_decorated_content(text: ['John', '18'])
      expect(subject.cells[1]).to have_decorated_content(text: ['Jane', '25'])
    end

    it 'counts items' do
      expect(subject.summary).to eq(2)
    end
  end

  context 'with Array of Structs' do
    let(:collection) { [john_struct, jane_struct] }

    it_behaves_like 'handles collection'
  end

  context 'with Set of Structs' do
    let(:collection) { [john_struct, jane_struct].to_set }

    it_behaves_like 'handles collection'
  end

  context 'with Array of Hashes' do
    let(:collection) { [john_hash, jane_hash] }

    it_behaves_like 'handles collection'
  end

  context 'with Set of Hashes' do
    let(:collection) { [john_hash, jane_hash].to_set }

    it_behaves_like 'handles collection'
  end

  context 'with Array of incompatible data' do
    let(:collection) { [1, 2, 3] }

    it do
      expect(subject.valid?).to eq(false)
    end
  end
end
