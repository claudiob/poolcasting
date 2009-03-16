class CreateIdentifications < ActiveRecord::Migration
  def self.up
    create_table :identifications do |t|
      t.integer :item_id #polymorphic
      t.string  :item_type, :default => 'Song', :limit => 16
      t.integer :identifier_id #polymorphic
      t.string  :identifier_type, :default => 'Opensong', :limit => 16
    end
    add_index :identifications, [:item_id, :item_type, :identifier_id, 
      :identifier_type], :name => :pair, :unique => true
    add_index :identifications, [:item_id, :item_type], :name => :item
    add_index :identifications, [:identifier_id, :identifier_type], 
      :name => :identifier 
  end

  def self.down
    drop_table :identifications
  end
end
