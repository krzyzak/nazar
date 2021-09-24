# frozen_string_literal: true

require 'sequel'

DB = Sequel.sqlite

DB.create_table :users do
  primary_key :id
  String :name
  TrueClass :active
end

class SequelUser < Sequel::Model(:users)
end
