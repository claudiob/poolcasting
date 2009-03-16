require 'zip/zip'

class CreateArtists < ActiveRecord::Migration
  def self.up
    include Importable
    create_table :artists do |t|
      t.string :name
    end
    Zip::ZipFile.open('db/data/playlists.zip') { |zipfile|
      fast_import zipfile, Artist, [:id, :name] 
    }
  end

  def self.down
    drop_table :artists
  end
end
