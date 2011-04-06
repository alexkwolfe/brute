class CreateCalls < ActiveRecord::Migration
  def self.up
    create_table :calls do |t|
      t.string :caller_number
      t.string :target_number

      t.timestamps
    end
  end

  def self.down
    drop_table :calls
  end
end
