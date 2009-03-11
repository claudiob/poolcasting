class CreateCooccurrences < ActiveRecord::Migration
  def self.up
    create_table :cooccurrences do |t| # should add :id => false
      t.references :song
      t.integer :next_song_id
      t.integer :d1
      t.integer :d2
      t.integer :d3
    end
    add_index :cooccurrences, [:song_id, :next_song_id], :unique => true 
    add_index :cooccurrences, :song_id
    add_index :cooccurrences, :next_song_id
  end

  def self.down
    drop_table :cooccurrences
  end
end
