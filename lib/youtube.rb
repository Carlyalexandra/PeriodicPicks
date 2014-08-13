require 'rubygems'
require 'google/api_client'
require 'trollop'

ENV["GOOGLE_API_KEY"]

DEVELOPER_KEY = ENV["GOOGLE_API_KEY"] 
YOUTUBE_API_SERVICE_NAME = 'youtube'
YOUTUBE_API_VERSION = 'v3'

class Youtube

    def get_service
      client = Google::APIClient.new(
        :key => DEVELOPER_KEY,
        :authorization => nil,
        :application_name => $PERIODIC_PICK,
        :application_version => '1.0.0'
      )
      youtube = client.discovered_api(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION)

      return client, youtube
    end

    def main(q)
      opts = Trollop::options do
        opt :q, 'Search term', :type => String, :default => 'New York City'
        opt :max_results, 'Max results', :type => :int, :default => 24
      end

      client, youtube = get_service

      begin
        # Call the search.list method to retrieve results matching the specified
        # query term.
        search_response = client.execute!(
          :api_method => youtube.search.list,
          :parameters => {
            :part => 'snippet',
            :q => q,
            :maxResults => opts[:max_results]
          }
        )
        
        videos = []
        
        search_response.data.items.each do |search_result|
          case search_result.id.kind
            when 'youtube#video'
              videos << {title: "#{search_result.snippet.title}", id: "#{search_result.id.videoId}"}
            # when 'youtube#channel'
            #   channels << "#{search_result.snippet.title} (#{search_result.id.channelId})"
            # when 'youtube#playlist'
            #   playlists << "#{search_result.snippet.title} (#{search_result.id.playlistId})"
          end
        end

        # puts "Videos:\n", videos, "\n"
        # puts "Channels:\n", channels, "\n"
        # puts "Playlists:\n", playlists, "\n"
      rescue Google::APIClient::TransmissionError => e
        puts e.result.body
      end
        videos
    end
end