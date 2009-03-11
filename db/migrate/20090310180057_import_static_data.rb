require 'zip/zip'
require 'fastercsv'
require 'ar-extensions'

class ImportStaticData < ActiveRecord::Migration # could be renamed Import Legacy Data
  include Importable
  def self.up
    Zip::ZipFile.open('db/data/cooccurrences.zip') { |zipfile|
      fast_import zipfile, Genre, [:id, :name, :popularity]
      fast_import zipfile, Artist, [:id, :name, :popularity] 
      fast_import zipfile, Song, [:id, :name, :artist_id, :genre_id, :popularity] 
      fast_import zipfile, Cooccurrence, [:song_id, :next_song_id, :d1, :d2, :d3] 
    }
  end

  def self.down
    Cooccurrence.delete_all
    Song.delete_all
    Genre.delete_all
    Artist.delete_all
  end
end

