# frozen_string_literal: true

require 'spec_helper'
require 'active_record_helper'

Nazar.load_active_record!

RSpec.describe Nazar::Formatter::SequelItem do
  subject { described_class.new(item) }

  let(:item) { SequelUser.create(name: 'John Doe', active: true) }

  after(:each) do
    DB[:users].delete
  end

  after(:all) do
    unload_sequel!
  end

  it do
    expect(subject.valid?).to eq(true)
  end

  it 'formats headers' do
    expect(subject.headers).to have_decorated_content(text: ['id', 'name', 'active'], decorations: { style: :bold })
  end

  it 'converts cells' do
    expect(subject.cells.size).to eq(1)

    expect(subject.cells.first).to have_decorated_content(text: [item.id.to_s, 'John Doe', '✓'])
  end

  it 'does not return summary' do
    expect(subject.summary).to eq(false)
  end
end
