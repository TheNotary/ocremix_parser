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
end
