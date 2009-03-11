class CreateSongs < ActiveRecord::Migration
  def self.up
    create_table :songs do |t|
      t.references :artist
      t.references :genre
      t.string :name
      t.integer :popularity
    end
    add_index :songs, :artist_id
    add_index :songs, :genre_id
  end

  def self.down
    drop_table :songs
  end
end
