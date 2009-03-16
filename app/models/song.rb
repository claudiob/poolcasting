class Song < ActiveRecord::Base
  belongs_to :artist
  has_many :identifications,  :as => :item
  has_many :cooccurrences, :class_name => "cooccurrence", :foreign_key => "song_id"
  has_many :postoccurrences, :class_name => "cooccurrence", :foreign_key => "next_song_id"
  # delegate :first_artist, :next_artist
  has_many :associations, :through => :cooccurrences
  named_scope :occurring_after, lambda { |first_song| 
    { :joins => "JOIN cooccurrences ON next_song_id = songs.id",
      :conditions => ['song_id = ?', first_song] }}  
  named_scope :not_occurring_after, lambda { |first_song| 
    { :conditions => ['id NOT IN (SELECT DISTINCT next_song_id FROM
      cooccurrences WHERE song_id = ?)', first_song] }}  
  named_scope :identified, :joins => "JOIN identifications ON 
    item_type = 'Song' AND item_id = songs.id"
  
  def title
    # This will be overwritten by the identifier
    "#{self.name} | #{self.artist.name}"
  end
end
