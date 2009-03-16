require 'zip/zip'

class CreateSongs < ActiveRecord::Migration
  def self.up
    include Importable
    create_table :songs do |t|
      t.string :name
      t.references :artist
    end
    add_index :songs, :artist_id
    Zip::ZipFile.open('db/data/playlists.zip') { |zipfile|
      fast_import zipfile, Song, [:id, :name, :artist_id] 
    }
  end

  def self.down
    drop_table :songs
  end
end
