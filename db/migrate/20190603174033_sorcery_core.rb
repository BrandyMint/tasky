# frozen_string_literal: true

class SorceryCore < ActiveRecord::Migration[5.2]
  def change
    change_table :users do |t|
      t.string :crypted_password
      t.string :salt
    end
  end
end
