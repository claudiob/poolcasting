require 'zip/zip'
require 'ar-extensions'

class FixStaticData < ActiveRecord::Migration
  include Importable
  def self.up
    # Change column names
    rename_column :songs, :popularity, :csp
    rename_column :genres, :popularity, :csp
    rename_column :artists, :popularity, :csp
    
    # Recreate cooccurrences as polymorphic
    drop_table :cooccurrences
    create_table :cooccurrences, :force => true do |t|
      # Not using :polymorphic since varchar(255) would make an index too long
      t.integer :predecessor_id
      t.string  :predecessor_type, :limit => 16, :default => 'Song'
      t.references :successor, :polymorphic => true
      t.integer :successor_id
      t.string  :successor_type, :limit => 16, :default => 'Song'
      t.integer :d1
      t.integer :d2
      t.integer :d3
    end
    add_index :cooccurrences, [:predecessor_id, :predecessor_type,
      :successor_id, :successor_type], :name => 'pair', :unique => true 
    add_index :cooccurrences, :predecessor_type
    add_index :cooccurrences, [:predecessor_id, :predecessor_type]
    add_index :cooccurrences, [:successor_id, :successor_type]
 
    # Reload all data (Previously some songs were missing)
    Cooccurrence.delete_all
    Song.delete_all
    Genre.delete_all
    Artist.delete_all
    Zip::ZipFile.open('db/data/cooccurrences.zip') { |zipfile|
      fast_import zipfile, Genre, [:id, :name, :csp]
      fast_import zipfile, Artist, [:id, :name, :csp] 
      fast_import zipfile, Song, [:id, :name, :artist_id, :genre_id, :csp] 
      fast_import zipfile, Cooccurrence, [:predecessor_id, :predecessor_type, 
       :successor_id, :successor_type, :d1, :d2, :d3]
    }

    # Calculate artist-to-artist co-occurrences
    new_coocc = Cooccurrence.all(:select => "s1.artist_id AS predecessor_id, \
      'Artist' AS predecessor_type, s2.artist_id AS successor_id, \
      'Artist' AS successor_type, SUM(d1) AS d1, SUM(d2) AS d2, SUM(d3) AS d3",
      :joins => "INNER JOIN songs s1 ON predecessor_id = s1.id \
      INNER JOIN songs s2 ON successor_id = s2.id",  
      :group => 's1.artist_id, s2.artist_id')
    columns = new_coocc.first.attributes.keys
    data = new_coocc.collect{ |h| h.attributes.values }
    # BUG: Why does the next import INSERT one item at the time (not multiple)? 
    Cooccurrence.import columns, data, {:validate => false}
  end

  def self.down
    # ActiveRecord::IrreversibleMigration
    rename_column :artists, :csp, :popularity
    rename_column :genres, :csp, :popularity
    rename_column :songs, :csp, :popularity
    drop_table :cooccurrences
    Song.delete_all
    Genre.delete_all
    Artist.delete_all
  end
end