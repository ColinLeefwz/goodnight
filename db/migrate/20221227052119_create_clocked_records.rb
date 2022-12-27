class CreateClockedRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :clocked_records do |t|
      t.datetime :clocked_in
      t.integer :slot_seconds
      t.integer :status, null: false, default: 0
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :clocked_records, :status
  end
end
