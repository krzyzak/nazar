# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Nazar::VerticalTable do
  subject { described_class.new(headers, cells) }
  let(:headers) { ['Id', 'Name', 'Age'] }
  let(:cells) { [[1, 'John', 27], [2, 'Jane', 35]] }
  let(:green_line) { "\e[32m────────────\e[0m\n" }

  describe '#render' do
    it 'renders data vertically' do
      expect(subject.render.each_line.to_a).to eq([
        green_line,
        "Id   1   \n",
        green_line,
        "Name John\n",
        "Age  27  \n",
        green_line,
        "Id   2   \n",
        green_line,
        "Name Jane\n",
        "Age  35  \n",
        green_line.chomp
      ])
    end
  end
end
