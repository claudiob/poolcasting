require 'zip/zip'

class ImportStaticData < ActiveRecord::Migration # could be renamed Legacy Data
  include Importable
  def self.up
    Zip::ZipFile.open('db/data/cooccurrences.zip') { |zf|
      fast_import zf, Genre, [:id, :name, :popularity]
      fast_import zf, Artist, [:id, :name, :popularity] 
      fast_import zf, Song, [:id, :name, :artist_id, :genre_id, :popularity] 
      fast_import zf, Cooccurrence, [:song_id, :next_song_id, :d1, :d2, :d3] 
    }
  end

  def self.down
    Cooccurrence.delete_all
    Song.delete_all
    Genre.delete_all
    Artist.delete_all
  end
end

