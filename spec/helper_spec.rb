require 'spec_helper'

describe Tableficate::Helper, type: :request do
  describe 'tableficate_filter_tag' do
    it 'allows for collection to accept a string' do
      visit '/filters/select_from_string'
      page.should have_xpath("//select[@id='nobel_prize_winners_filter_category']/option[text()='Peace']")
    end
    it 'selects option from params when collection is a string' do
      visit '/filters/select_from_string?nobel_prize_winners[filter][category]=Peace'
      page.should have_xpath("//select[@id='nobel_prize_winners_filter_category']/option[text()='Peace'][@selected='selected']")
    end

    it 'allows for collection to accept a generated string' do
      visit '/filters/select_from_generated_string'
      page.should have_xpath("//select[@id='nobel_prize_winners_filter_category']/option[@value='Peace']")
    end
    it 'selects option from params when collection is a generated string' do
      visit '/filters/select_from_generated_string?nobel_prize_winners[filter][category]=Peace'
      page.should have_xpath("//select[@id='nobel_prize_winners_filter_category']/option[@value='Peace'][@selected='selected']")
    end
  end
end
