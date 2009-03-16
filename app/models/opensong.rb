require 'rexml/document'
require 'net/http'
require "uri"

class Opensong < ActiveRecord::Base
  has_many :identifications,  :as => :identifier

  def self.fetch_all
    Song.find_in_batches(:batch_size => 50, :include => [:artist],
      :joins => "LEFT JOIN identifications ON item_id = songs.id",
      :conditions => "identifications.id IS NULL") do |batch|
      @metadata = Opensong.match_tracks(batch.collect{|song| 
        "#{song.artist.name}||#{song.name}"}
      )
      @metadata.each_with_index do |identified_song, index|
        if identified_song[:track_id] > 0
          o = Opensong.find_or_create_by_track_id(identified_song)
          o.identifications.create(:item_id => batch[index].id, 
                                   :item_type => "Song")
        end
      end
    end
  end

    env = ENV['RAILS_ENV'] || RAILS_ENV
    config = YAML.load_file(RAILS_ROOT + '/config/openstrands.yml')[env]
    Key = config['api_key']

    def self.match_tracks(names)
      path = "/internalservices/match/tracks?subscriberId=#{Key}"
      # Should pack ids in calls by 50 or 100
      # Should retry for HTTP errors
      
      # Important note: only '&' are cleaned out, '|' should be as well,
      # and also unicode characters, double quotes, etc.
      names.each { |name| path += "&name=#{name.gsub(/\&/, '%22')}" }
      attributes_to_retrieve = ['TrackId', 'ArtistId']
      fields_to_retrieve = ['TrackName', 'WmaClipURI', 'CoverURI', 'AlbumName',
                            'ArtistName', 'RmClipURI', 'RmMobileClipURI', 
                            'SmallCoverURI', 'Genre', 'URI']
      data = fetch_openstrands(path)
      if not data == false
        xml = REXML::Document.new(data)	
        tracks = []
        xml.root.elements.each do |element|
          track = {}
          track["track_id"] = element.attributes["TrackId"].to_i
          track["artist_id"] = element.attributes["ArtistId"].to_i
          unless track["track_id"] < 0
            fields_to_retrieve.each do |field|
              track[field.underscore] = element.elements[field] ?
                element.elements[field].text : ''
            end
          end
          track.symbolize_keys!
          tracks.push track # not an hash cause I have no unique index
        end
      end
      return tracks
    end 



  private

  def self.fetch_openstrands(path)
        http = Net::HTTP.new("www.mystrands.com",80)
        path = url(path)
        resp, data = http.get(path)
        while resp.code != "200"
          logger.error "HTTP ERROR, retry"
          logger.error resp.code
          logger.error data
          logger.error path
          sleep(5)
          resp, data = http.get(path)
        end
        if resp.code == "200"
          return data
        else
          return false
        end	
  end

  def self.url(string)
    return  string.gsub(/\ +/, '%20')
  end

    
end

