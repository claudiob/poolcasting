class CreateAssociations < ActiveRecord::Migration
  def self.up
    create_table :associations do |t|
      t.references :cooccurrence
      t.references :parameter
      t.float :song_to_song
      t.float :song_to_artist
      t.float :artist_to_artist
    end
  end

  def self.down
    drop_table :associations
  end
end
