# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Nazar::View do
  subject { described_class.new(data, layout: layout) }
  let(:layout) { :auto }

  let(:dummy_formatter_klass) { double(new: dummy_formatter, valid?: true) }
  let(:dummy_formatter) { double(valid?: valid, headers: headers, cells: cells, summary: summary) }
  let(:data) { '' }
  let(:headers) { ['ID', 'NAME'] }
  let(:cells) { [[1, 'foo'], [2, 'bar']] }
  let(:summary) { false }
  let(:valid) { true }

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

    context 'with Struct' do
      let(:data) { Struct.new(:id, :name).new(1, 'foo') }


      context 'without loaded extension' do
        it do
          expect(subject).not_to be_supported_data
        end
      end

      context 'with loaded extension' do
        before do
          Nazar.load_struct!
        end

        after do
          unload_struct!
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

    context 'with unsupported data' do
      let(:valid) { false }

      it 'does not render data' do
        expect(subject.render).to eq(nil)
      end
    end

    context 'with supported data' do
      let(:valid) { true }

      it 'renders data' do
        expect(Nazar::HorizontalTable).to receive(:new)
          .with(headers, cells)
          .and_return(double(render: 'SOME-TABLE'))

        expect(subject.render).to eq('SOME-TABLE')
      end

      context 'with summary' do
        let(:summary) { 5 }

        it 'renders data with summary' do
          expect_any_instance_of(Nazar::HorizontalTable).to receive(:add_summary).with(5)

          subject.render
        end
      end
    end
  end

  describe '#layout' do
    let(:data) { 'a ' * 100 }
    before do
      Nazar.formatters << dummy_formatter_klass
    end

    after do
      Nazar.formatters.delete(dummy_formatter_klass)
    end

    context 'with auto layout' do
      let(:layout) { :auto }

      context 'when data is too wide to fit in the terminal' do
        it 'returns vertical layout' do
          allow(TTY::Screen).to receive(:width).and_return(1)
          expect(subject.layout).to eq(:vertical)
        end
      end

      context 'when data is narrow enough to fit in the terminal' do
        it 'returns horizontal layout' do
          allow(TTY::Screen).to receive(:width).and_return(110)
          expect(subject.layout).to eq(:horizontal)
        end
      end
    end

    context 'with horizontal layout' do
      let(:layout) { :horizontal }

      it 'renders data horizontally' do
        allow(TTY::Screen).to receive(:width).and_return(1)
        expect(subject.layout).to eq(:horizontal)
      end
    end

    context 'with vertical layout' do
      let(:layout) { :vertical }

      it 'renders data vertically' do
        allow(TTY::Screen).to receive(:width).and_return(110)
        expect(subject.layout).to eq(:vertical)
      end
    end
  end
end
