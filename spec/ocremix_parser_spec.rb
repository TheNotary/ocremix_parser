require 'spec_helper'

describe OcremixParser do

  before :each do
    @title_string = "Super Smash Bros. for Wii U 'Incognito'"
    @download_file_name = "Super_Smash_Bros_for_Wii_U_Incognito_OC_ReMix.mp3"
  end

  it 'has a version number' do
    expect(OcremixParser::VERSION).not_to be nil
  end

  it 'can convert a title to a download name' do
    expect(OcremixParser.convert_title_to_filename(@title_string)).to eq(@download_file_name)
  end

  it 'can convert foriegn lang symbols into ascii english' do
    forieng_string = "Pokkén Tournament 'Iron-Headed Pursuit'"
    expected_string = "Pokken_Tournament_Iron-Headed_Pursuit_OC_ReMix.mp3"

    expect(OcremixParser.convert_title_to_filename(forieng_string)).to eq expected_string
  end

  it 'can return an array of titles from an rss feed' do
    titles = OcremixParser.get_top_ten_file_names

    expect(titles.count).to eq 10
  end
end
