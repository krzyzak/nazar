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
end
