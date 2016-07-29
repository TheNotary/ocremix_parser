require 'spec_helper'

describe OcremixParser do

  it 'has a version number' do
    expect(OcremixParser::VERSION).not_to be nil
  end

  it 'creates a config file in the correct place' do
    expected_config_file_path = "#{ENV['HOME']}/.config/ocremix_parser.yml"
    @mix_grabber = OcremixParser::MixGrabber.new

    expect(File.exists? expected_config_file_path).to be_truthy
  end

  describe "MixGrabber" do

    before :each do
      @mix_grabber = OcremixParser::MixGrabber.new
      @title_string = "Super Smash Bros. for Wii U 'Incognito'"
      @download_file_name = "Super_Smash_Bros_for_Wii_U_Incognito_OC_ReMix.mp3"
    end

    it 'can convert a title to a download name' do
      expect(@mix_grabber.convert_title_to_filename(@title_string)).to eq(@download_file_name)
    end

    it 'can convert foriegn lang symbols into ascii english' do
      forieng_string = "Pokkén Tournament 'Iron-Headed Pursuit'"
      expected_string = "Pokken_Tournament_Iron-Headed_Pursuit_OC_ReMix.mp3"

      expect(@mix_grabber.convert_title_to_filename(forieng_string)).to eq expected_string
    end

    it 'should be able to extract the .mp3 links from a track page' do
      url = "http://ocremix.org/remix/OCR03341"
      expect(@mix_grabber.convert_track_page_to_mp3_links(url).count).to eq 3
    end

    it 'can return an array of titles from an rss feed' do
      titles = @mix_grabber.query_from_top_ten_rss_feed

      expect(titles.count).to eq 10
    end

  end

end
