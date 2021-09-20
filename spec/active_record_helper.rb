# frozen_string_literal: true

Nazar.load_active_record!

ActiveRecord::Migration.verbose = false

config = {
  sqlite: {
    adapter: 'sqlite3',
    database: ':memory:'
  }
}

ActiveRecord::Base.configurations = config
ActiveRecord::Base.establish_connection(:sqlite)

ActiveRecord::Schema.define(version: 0) do
  create_table :users, force: true do |t|
    t.string :name
    t.boolean :active
  end
end

class User < ActiveRecord::Base
end
