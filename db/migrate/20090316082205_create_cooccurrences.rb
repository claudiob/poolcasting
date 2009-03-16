require 'zip/zip'

class CreateCooccurrences < ActiveRecord::Migration
  def self.up
    include Importable
    create_table :cooccurrences do |t|
      t.references :song
      t.integer :next_song_id
      t.boolean :fake, :default => false
      t.integer :d1, :default => 0, :null => false
      t.integer :d2, :default => 0, :null => false
      t.integer :d3, :default => 0, :null => false
    end
    add_index :cooccurrences, :song_id
    add_index :cooccurrences, :next_song_id
    add_index :cooccurrences, [:song_id, :next_song_id], :unique => true
    add_index :cooccurrences, :fake
    Zip::ZipFile.open('db/data/playlists.zip') { |zipfile|
      fast_import zipfile, Cooccurrence, [:song_id, :next_song_id, :d1, :d2, :d3] 
    }
  end

  def self.down
    drop_table :cooccurrences
  end
end
