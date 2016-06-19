require 'figaro'
require 'open-uri'
require 'simple-rss'

require "ocremix_parser/version"

Figaro.application.path = File.expand_path('../../config/application.yml', __FILE__)
Figaro.load

module OcremixParser

  def self.get_latest_remixes
    # pull down the latest file_names from the rss feed
    top_ten_file_names = get_top_ten_file_names

    mirror = ENV['file_mirrors'].split(" ").last

    top_ten_file_names.each do |file_name|
      source_path = "#{mirror}/#{file_name}"
      target_location = "#{ENV['download_directory']}/#{file_name}"
      next if File.exists? target_location

      # Download with a progress bar...
      # Wget user agent required (I have an odd firewall...)!
      cmd = "wget #{source_path} -O #{target_location}"
      `#{cmd}`
    end
  end

  def self.convert_title_to_filename(string)
    tag = "_OC_ReMix.mp3"
    string.gsub(" ", "_").gsub(/[^0-9A-Za-z_\-]/, "") + tag
  end

  def self.get_top_ten_file_names
    rss = SimpleRSS.parse open(ENV['rss_feed'])
    rss.entries.map {|e| convert_title_to_filename(e.title) }
  end

  # Not Used...
  def self.download_bad_way(target_location, source_path)
    useragent = "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:47.0) Gecko/20100101 Firefox/47.0"

    # Download without a progress bar
    File.open(target_location, "wb") do |saved_file|
      # the following "open" is provided by open-uri
      open("#{source_path}", "rb", 'User-Agent' => useragent) do |read_file|
        saved_file.write(read_file.read)
      end
    end
  end

end
