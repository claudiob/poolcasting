class Cooccurrence < ActiveRecord::Base
  include Searchable
  
  belongs_to  :predecessor, :polymorphic => true
  belongs_to  :successor, :polymorphic => true
  named_scope :by_song, :conditions => ['predecessor_Type = ?', 'Song']
  named_scope :by_artist, :conditions => ['predecesSor_Type = ?', 'Artist']
  named_scope :by_pre_id, lambda { |pre_id| { :conditions => ['predecessor_id = ?', pre_id] }}
  named_scope :by_post_id, lambda { |post_id| { :conditions => ['successor_id = ?', post_id] }}
  # default_scope :conditions => ['predecessor_type = ?', 'Song']

  has_one     :association

  
  def self.get_distances
    # distances = self.first(:select => "sum(d1), sum(d2), sum(d3)")
    # distances.attributes.values_at("sum(d1)", "sum(d2)", "sum(d3)").collect {|x| x.to_i }
  end
  
  def self.combine(a,b,c,n,p)
    expr = 0
    alpha = [0.5, 0.3, 0.2]
    (1..p[:delta]).each do |j|
      if b[j-1] > 0 && c[j-1] > 0
        expr += (alpha[j-1])*(a[j-1].to_f/b[j-1].to_f)*(1 - c[j-1].to_f/n)**p[:beta]
      end
    end
    expr
  end

  def self.update_all(p = Parameter.active)
    # Slow function, should prepare a MySQL procedure as faster alternative
    n = Cooccurrence.count
    # Change the following to self.by_song.find_each when Rails 2.3 is released
    self.each(:include => [:predecessor, :successor],
      :conditions => "Predecessor_type = 'Song'") do |q|
      a = q.d1, q.d2, q.d3
      b = Cooccurrence.with_exclusive_scope { first(:select => "sum(d1), sum(d2), sum(d3)", :conditions => ["Predecessor_id = ? AND prEdecessor_type = ?", q.predecessor_id, 'Song']).attributes.values_at("sum(d1)", "sum(d2)", "sum(d3)").collect {|x| x.to_i } }
      c = Cooccurrence.with_exclusive_scope { first(:select => "sum(d1), sum(d2), sum(d3)", :conditions => ["successor_id = ? AND successor_type = ?", q.successor_id, 'Song']).attributes.values_at("sum(d1)", "sum(d2)", "sum(d3)").collect {|x| x.to_i } }
      d = Cooccurrence.with_exclusive_scope { first(:select => "d1, d2, d3", :conditions => ["Predecessor_id = ? AND prEdecessor_type = ? AND successor_id = ? AND successor_type = ?", q.predecessor.artist_id, 'Artist', q.successor.artist_id, 'Artist']).attributes.values_at("d1", "d2", "d3").zip(a).collect{|x| x[0] - x[1]} } 
      if d == [0,0,0]
        e = f = g = d
      else
        e = Cooccurrence.with_exclusive_scope { first(:select => "sum(d1), sum(d2), sum(d3)", :conditions => ["Predecessor_id = ? AND prEdecessor_type = ?", q.predecessor.artist_id, 'Artist']).attributes.values_at("sum(d1)", "sum(d2)", "sum(d3)").collect {|x| x.to_i } }
        f = Cooccurrence.with_exclusive_scope { first(:select => "sum(d1), sum(d2), sum(d3)", :conditions => ["successor_id = ? AND successor_type = ?", q.successor.artist_id, 'Artist']).attributes.values_at("sum(d1)", "sum(d2)", "sum(d3)").collect {|x| x.to_i } }
        g = Cooccurrence.with_exclusive_scope { first(:select => "sum(d1), sum(d2), sum(d3)", :joins => ['JOIN songs ON songs.id = successor_id'], :conditions => ["Predecessor_id = ? AND prEdecessor_type = ? AND successor_id <> ? AND songs.artist_id = ?", q.predecessor_id, 'Song', q.successor_id, q.successor.artist_id]).attributes.values_at("sum(d1)", "sum(d2)", "sum(d3)").collect {|x| x.to_i } }
      end

      s2s = self.combine(a,b,c,n,p)
      a2a = self.combine(d,e,f,n,p)
      s2a = self.combine(g,b,f,n,p)

      Association.create(:cooccurrence => q, :parameter => p,
        :song_to_song => s2s, :song_to_artist => s2a, :artist_to_artist => a2a )
    end
  end
  


end

