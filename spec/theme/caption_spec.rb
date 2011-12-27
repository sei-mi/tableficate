require 'spec_helper'

describe 'Theme', type: :request do
  describe 'Caption' do
    it 'should display a caption if one is specified' do
      visit '/themes/caption'
      page.should have_xpath('//caption[text()="Nobel Prize Winners"]')
    end

    it 'should display no caption if no caption is specified' do
      visit '/themes/no_caption'
      page.should have_no_xpath('//caption')
    end
  end
end
