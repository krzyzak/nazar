# frozen_string_literal: true

RSpec.describe Nazar do
  it 'has a version number' do
    expect(Nazar::VERSION).not_to be nil
  end

  describe '#enable!' do
    after(:each) do
      Object.send(:remove_const, :Pry) if defined?(Pry)
      Object.send(:remove_const, :IRB) if defined?(IRB)

      Nazar.disable!
    end

    context 'when Pry is defined' do
      it do
        ::Pry = double

        expect(Nazar).to receive(:enable_for_pry!)
        expect(Nazar).not_to receive(:enable_for_irb!)

        Nazar.enable!
      end
    end

    context 'when IRB is defined' do
      it do
        ::IRB = double

        expect(Nazar).not_to receive(:enable_for_pry!)
        expect(Nazar).to receive(:enable_for_irb!)

        Nazar.enable!
      end
    end

    context 'with default extensions list' do
      it 'loads formatters for ActiveRecord' do
        Nazar.enable!

        expect(Nazar.formatters).to include(Nazar::Formatter::ActiveRecordCollection,
                                            Nazar::Formatter::ActiveRecordItem)
      end

      it 'loads formatter for CSV' do
        Nazar.enable!

        expect(Nazar.formatters).to include(Nazar::Formatter::CSVTable)
      end
    end

    context 'with custom extensions' do
      context 'with Sequel' do
        it 'loads formatters for Sequel' do
          Nazar.enable!(extensions: [:sequel])

          expect(Nazar.formatters).to include(Nazar::Formatter::SequelCollection, Nazar::Formatter::SequelItem)
        end
      end
    end
  end
end
