class Association < ActiveRecord::Base
  include Randomable
  belongs_to :cooccurrence
  belongs_to :parameter
  named_scope :identified, :conditions => {},
    :joins => "JOIN cooccurrences ON cooccurrences.id = cooccurrence_id \
    JOIN songs s1 ON s1.id = song_id JOIN songs s2 ON s2.id = next_song_id \
    JOIN identifications i1 ON i1.item_type = 'Song' AND \
    i1.item_id = song_id JOIN identifications i2 ON i2.item_type = 'Song' AND \
    i2.item_id = next_song_id", :conditions => "NOT cooccurrences.fake"

    
  # to add: validate degree > 0
  def self.create_or_random
    if rand(2).zero?
      # Return an identified association at random
      self.identified.random   
    else
      # Create a fake cooccurrence and a fake association
      s1 = Song.identified.random
      s2 = Song.identified.not_occurring_after(s1).random
      # Add they should not be from the same artist or song
      c = Cooccurrence.create(:first_song => s1, :next_song => s2, :fake => true)
      Association.create(:cooccurrence => c, :parameter => Parameter.active)
    end
  end
  
  def before_save
    self.song_to_song, self.song_to_artist, self.artist_to_artist,
      self.degree = self.calculate_degrees
  end
  
  def calculate_degrees
    counts = self.cooccurrence.cumulative_counts
    s2s = Association.combine(counts[:song_to_song], self.parameter)
    s2a = Association.combine(counts[:song_to_artist], self.parameter)
    a2a = Association.combine(counts[:artist_to_artist], self.parameter)
    deg = (1-self.parameter[:phi2]-self.parameter[:phi3])*s2s + 
    self.parameter[:phi2]*s2a + self.parameter[:phi3]*a2a
    return s2s, s2a, a2a, deg
  end
  
  def self.combine(values, params)
    n = Cooccurrence.count
    expr = []
    (0..2).each do |j|
      if values[:first][j] > 0 && values[:next][j] > 0
        expr.push( (values[:both][j].to_f/values[:first][j].to_f) * 
                   (1 - values[:next][j].to_f/n)**params[:beta] )
      else
        expr.push 0
      end
    end
    (1 - params[:alpha2] - params[:alpha3])*expr[0] + 
    params[:alpha2]*expr[1] + params[:alpha3]*expr[2]
  end
end
