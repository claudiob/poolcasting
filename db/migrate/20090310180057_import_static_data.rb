require 'zip/zip'
require 'fastercsv'
require 'ar-extensions'

class ImportStaticData < ActiveRecord::Migration # could be renamed Import Legacy Data
  def self.up
    Zip::ZipFile.open('db/data/cooccurrences.zip') { |zipfile|
      genres = FasterCSV.parse(zipfile.read('genres.csv'))
      Genre.import [:id, :name, :popularity], genres, {:validate => false}

      artists = FasterCSV.parse(zipfile.read('artists.csv'))
      Artist.import [:id, :name, :popularity], artists, {:validate => false}

      songs = FasterCSV.parse(zipfile.read('songs.csv'))
      Song.import [:id, :name, :artist_id, :genre_id, :popularity], songs, {:validate => false}

      # The next is very slow (4432.2081s), so I should rewrite this with a direct MySQL multiple insert statement
      coocc = FasterCSV.parse(zipfile.read('cooccurrences.csv'))
      Cooccurrence.import [:song_id, :next_song_id, :d1, :d2, :d3], coocc, {:validate => false}
    }
  end

  def self.down
    Cooccurrence.delete_all
    Song.delete_all
    Genre.delete_all
    Artist.delete_all
  end
end

