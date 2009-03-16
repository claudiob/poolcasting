class CreateAssociations < ActiveRecord::Migration
  def self.up
    create_table :associations do |t|
      t.references :cooccurrence
      t.references :parameter
      t.float :degree, :default => 0, :null => false
      t.float :song_to_song, :default => 0, :null => false
      t.float :song_to_artist, :default => 0, :null => false
      t.float :artist_to_artist, :default => 0, :null => false
    end
    add_index :associations, :cooccurrence_id
    add_index :associations, :parameter_id
    Cooccurrence.generate_associations
  end

  def self.down
    drop_table :associations
  end
end
