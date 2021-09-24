# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Nazar::View do
  subject { described_class.new(data) }

  describe '#supported_data?' do
    context 'with false' do
      let(:data) { false }

      it do
        expect(subject).not_to be_supported_data
      end
    end

    context 'with true' do
      let(:data) { true }

      it do
        expect(subject).not_to be_supported_data
      end
    end

    context 'with nil' do
      let(:data) { nil }

      it do
        expect(subject).not_to be_supported_data
      end
    end

    context 'with CSV Table' do
      let(:data) { CSV.parse("foo,bar\n1,2", headers: :first_row) }

      context 'without loaded extension' do
        it do
          expect(subject).not_to be_supported_data
        end
      end

      context 'with loaded extension' do
        before do
          Nazar.load_csv!
        end

        after do
          unload_csv!
        end

        it do
          expect(subject).to be_supported_data
        end
      end
    end
  end

  describe '#render' do
    before do
      Nazar.formatters << dummy_formatter_klass
    end

    after do
      Nazar.formatters.delete(dummy_formatter_klass)
    end

    let(:dummy_formatter_klass) { double(new: dummy_formatter, valid?: true) }
    let(:dummy_formatter) { double(valid?: valid, headers: headers, cells: cells, summary: summary) }
    let(:data) { '' }
    let(:headers) { ['ID', 'NAME'] }
    let(:cells) { [[1, 'foo'], [2, 'bar']] }
    let(:summary) { false }

    context 'with unsupported data' do
      let(:valid) { false }

      it 'does not render data' do
        expect(subject.render).to eq(nil)
      end
    end

    context 'with supported data' do
      let(:valid) { true }

      it 'renders data' do
        allow(Terminal::Table).to receive(:new)
          .with(hash_including(headings: headers, rows: cells))
          .and_return('SOME-TABLE')

        expect(subject.render).to eq('SOME-TABLE')
      end

      context 'with summary' do
        let(:summary) { 5 }

        it 'renders data with summary' do
          expect_any_instance_of(Terminal::Table).to receive(:add_row).with([anything, { value: 5, colspan: 1 }])

          subject.render
        end
      end
    end
  end
end
