class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :name
      t.boolean :flag,  :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
