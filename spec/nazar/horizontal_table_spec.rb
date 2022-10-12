# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Nazar::HorizontalTable do
  before do
    Nazar.config.table.resize = false
  end

  subject { described_class.new(headers, cells) }
  let(:headers) { ['Id', 'Name', 'Age'] }
  let(:cells) { [[1, 'John', 27], [2, 'Jane', 35]] }

  describe '#render' do
    it 'renders data horizontally' do
      expect(subject.render).to eq(<<~TABLE.chomp)
        ┌──┬────┬───┐
        │Id│Name│Age│
        ├──┼────┼───┤
        │1 │John│27 │
        ├──┼────┼───┤
        │2 │Jane│35 │
        └──┴────┴───┘
      TABLE
    end
  end
end
