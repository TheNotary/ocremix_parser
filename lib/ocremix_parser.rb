require 'i18n'
require 'figaro'
require 'open-uri'
require 'simple-rss'
require 'nokogiri'
require 'fileutils'

require "ocremix_parser/version"

module OcremixParser

  class MixGrabber

    def initialize
      prepare_config_file!

      @user_agent = '"Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:47.0) Gecko/20100101 Firefox/47.0"'
      @mirror = ENV['file_mirrors'].split(" ").last

      @skips = 0
      @downloads = 0
    end

    def prepare_config_file!
      bundled_config_path = File.expand_path('../../config/application.yml', __FILE__)
      config_path = "#{ENV['HOME']}/.config/ocremix_parser.yml"

      # create the config file unless it exists
      unless File.exists?(config_path)
        FileUtils.mkdir_p File.dirname(config_path)
        FileUtils.cp bundled_config_path, config_path
      end

      Figaro.application.path = config_path
      Figaro.load
    end

    def download_ten_latest_mixes_via_web_scrapes
      top_ten_track_page_links = query_from_top_ten_rss_feed(:link)

      top_ten_track_page_links.each do |page_url|
        dl_links = convert_track_page_to_mp3_links(page_url)
        file_name = File.basename(dl_links.first)
        destination_path = "#{ENV['download_directory']}/#{file_name}"

        wget_download(dl_links.first, destination_path)
      end

      puts "#{@downloads} downloads happened, #{@skips} skips"
    end

    def download_ten_latest_remixes_via_filename_guessing
      # pull down the latest file_names from the rss feed
      top_ten_file_names = query_from_top_ten_rss_feed.map {|s| convert_title_to_filename(s)}

      top_ten_file_names.each do |file_name|
        url = "#{@mirror}/#{file_name}"
        destination_path = "#{ENV['download_directory']}/#{file_name}"

        wget_download(url, destination_path)
      end
    end

    def wget_download(url, destination_path)
      if File.exists? destination_path
        @skips += 1
        return
      end

      @downloads += 1

      # Download with a progress bar...
      # Wget user agent required (I have an odd firewall...)!
      cmd = "wget #{url} -O #{destination_path} -U #{@user_agent}"
      puts cmd
      `#{cmd}`
    end

    def convert_title_to_filename(string)
      tag = "_OC_ReMix.mp3"
      string = convert_foriegn_characters_to_en(string)

      string.gsub(" ", "_").gsub(/[^0-9A-Za-z_\-]/, "") + tag
    end

    def convert_foriegn_characters_to_en(string)
      I18n.available_locales = [:en]
      string = I18n.transliterate(string.force_encoding('utf-8'))
    end

    def query_from_top_ten_rss_feed(key_to_query = :title)
      rss = SimpleRSS.parse open(ENV['rss_feed'])
      rss.entries.collect {|e| e[key_to_query] }
    end

    # Not Used... handy if wget doesn't exist though...
    def download_bad_way(destination_path, source_path, user_agent)

      # Download without a progress bar
      File.open(destination_path, "wb") do |saved_file|
        # the following "open" is provided by open-uri
        open("#{source_path}", "rb", 'User-Agent' => useragent) do |read_file|
          saved_file.write(read_file.read)
        end
      end
    end

    # e.g. pass in http://ocremix.org/remix/OCR03341
    # returns [ "http://mirrorname.com/file/path/File_Name.mp3", ... ]
    def convert_track_page_to_mp3_links(url)
      doc = Nokogiri.parse( open(url, "rb", 'User-Agent' => @user_agent).read )
      li_mirrors = doc.css("#panel-download > div:nth-child(1) > ul:nth-child(4) > li")
      download_links = li_mirrors.collect {|li| li.css("a").first["href"] }
    end

  end

end
