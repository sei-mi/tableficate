require 'spec_helper'

describe 'Theme', type: :request do
  describe 'Empty' do
    it 'should display text when the table has no data' do
      visit '/themes/empty_with_no_data'
      page.should have_xpath('//td[1][text()="There is no data."]')
    end

    it 'should not display text when the table has data' do
      visit '/themes/empty_with_data'
      page.should have_no_xpath('//td[1][text()="There is no data."]')
    end
  end
end
