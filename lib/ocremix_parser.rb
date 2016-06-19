require 'figaro'

require "ocremix_parser/version"

Figaro.application.path = File.expand_path('../../config/application.yml', __FILE__)
Figaro.load

module OcremixParser

  def self.get_latest_remixes
    # pull down the latest file_names from the rss feed

    # for each mirror, spawn a thread and initiate a wget if that file name does
    # not already exist in the path
  end

  def self.convert_title_to_filename(string)
    tag = "_OC_ReMix.mp3"
    string.gsub(" ", "_").gsub(/[^0-9A-Za-z_\-]/, "") + tag
  end

end
