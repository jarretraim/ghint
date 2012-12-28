class CreateTerminations < ActiveRecord::Migration
  def change
    create_table :terminations do |t|
      t.string :uuid,           :required => true
      t.datetime :updated,      :required => true
      t.string :username,       :required => true
      t.string :fullname
      t.string :manager
      t.string :location
      t.string :term_date
      t.string :processed_by
    end

    add_index :terminations, :uuid,        :unique => true
    add_index :terminations, :updated
  end
end
