require 'zip/zip'

class CreateOpensongs < ActiveRecord::Migration
  def self.up
    include Importable
    create_table :opensongs do |t|
      t.integer :track_id
      t.integer :artist_id
      t.string  :track_name
      t.string  :wma_clip_uri
      t.string  :cover_uri
      t.string  :album_name
      t.string  :artist_name
      t.string  :rm_clip_uri
      t.string  :rm_mobile_clip_uri
      t.string  :small_cover_uri
      t.string  :genre
      t.string  :uri
    end
    if File.exists? 'db/data/opensongs.zip' # tmp file to speed up loading
      Zip::ZipFile.open('db/data/opensongs.zip') { |zipfile|
        fast_import zipfile, Opensong, [:id, :track_id, :artist_id, 
          :track_name,:wma_clip_uri, :cover_uri, :album_name, :artist_name, 
          :rm_clip_uri, :rm_mobile_clip_uri, :small_cover_uri, :genre, :uri] 
        fast_import zipfile, Identification, [:id, :item_id, :item_type, 
          :identifier_id, :identifier_type] 
      }
    else
      Opensong.fetch_all
    end
  end

  def self.down
    drop_table :opensongs
  end
end
