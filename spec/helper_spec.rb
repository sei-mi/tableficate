require 'spec_helper'

describe Tableficate::Helper, type: :request do
  describe 'tableficate_select_tag' do
    it 'allows for a collection to accept a string' do
      visit '/filters/select_from_string'
      page.should have_xpath("//select[@id='nobel_prize_winners_filter_category']/option[text()='Peace']")
    end
    it 'selects an option from the params when the collection is a string' do
      visit '/filters/select_from_string?nobel_prize_winners[filter][category]=Peace'
      page.should have_xpath("//select[@id='nobel_prize_winners_filter_category']/option[text()='Peace'][@selected='selected']")
    end

    it 'allows for a collection to accept a range' do
      visit '/filters/select_from_range'
      page.should have_xpath("//select[@id='nobel_prize_winners_filter_year']/option[@value='1900']")
    end
    it 'selects an option from the params when the collection is a range' do
      visit '/filters/select_from_range?nobel_prize_winners[filter][year]=1903'
      page.should have_xpath("//select[@id='nobel_prize_winners_filter_year']/option[@value='1903'][@selected='selected']")
    end

    it 'allows for a collection to accept a hash' do
      visit '/filters/select_from_hash'
      page.should have_xpath("//select[@id='nobel_prize_winners_filter_category']/option[@value='Peace'][text()='3']")
    end
    it 'selects an option from the params when the collection is a range' do
      visit '/filters/select_from_hash?nobel_prize_winners[filter][category]=Peace'
      page.should have_xpath("//select[@id='nobel_prize_winners_filter_category']/option[@value='Peace'][@selected='selected']")
    end

    it 'allows for a collection to accept an array' do
      visit '/filters/select_from_array'
      page.should have_xpath("//select[@id='nobel_prize_winners_filter_category']/option[@value='Peace']")
    end
    it 'selects an option from the params when the collection is an array' do
      visit '/filters/select_from_array?nobel_prize_winners[filter][category]=Peace'
      page.should have_xpath("//select[@id='nobel_prize_winners_filter_category']/option[@value='Peace'][@selected='selected']")
    end

    it 'allows for a collection to accept a nested array' do
      visit '/filters/select_from_nested_array'
      page.should have_xpath("//select[@id='nobel_prize_winners_filter_category']/option[@value='Peace']")
    end
    it 'selects an option from the params when the collection is a nested array' do
      visit '/filters/select_from_nested_array?nobel_prize_winners[filter][category]=Peace'
      page.should have_xpath("//select[@id='nobel_prize_winners_filter_category']/option[@value='Peace'][@selected='selected']")
    end
  end

  describe 'tableficate_radio_tag' do
    it 'allows for a collection to accept a range' do
      visit '/filters/radio_from_range'
      page.should have_xpath("//input[@type='radio'][@id='nobel_prize_winners_filter_year_1901'][@value='1901']")
    end
    it 'selects an option from the params when the collection is a range' do
      visit '/filters/radio_from_range?nobel_prize_winners[filter][year]=1903'
      page.should have_xpath("//input[@type='radio'][@id='nobel_prize_winners_filter_year_1903'][@value='1903'][@checked='checked']")
    end

    it 'allows for a collection to accept a hash' do
      visit '/filters/radio_from_hash'
      page.should have_xpath("//label[@for='nobel_prize_winners_filter_category_Peace'][text()='3']")
      page.should have_xpath("//input[@type='radio'][@id='nobel_prize_winners_filter_category_Peace'][@value='Peace']")
    end
    it 'selects an choice from the params when the collection is a range' do
      visit '/filters/radio_from_hash?nobel_prize_winners[filter][category]=Peace'
      page.should have_xpath("//input[@type='radio'][@id='nobel_prize_winners_filter_category_Peace'][@value='Peace'][@checked='checked']")
    end

    it 'allows for a collection to accept an array' do
      visit '/filters/radio_from_array'
      page.should have_xpath("//input[@type='radio'][@id='nobel_prize_winners_filter_category_Peace'][@value='Peace']")
    end
    it 'selects an choice from the params when the collection is an array' do
      visit '/filters/radio_from_array?nobel_prize_winners[filter][category]=Peace'
      page.should have_xpath("//input[@type='radio'][@id='nobel_prize_winners_filter_category_Peace'][@value='Peace'][@checked='checked']")
    end

    it 'allows for a collection to accept a nested array' do
      visit '/filters/radio_from_nested_array'
      page.should have_xpath("//label[@for='nobel_prize_winners_filter_category_Peace'][text()='3']")
      page.should have_xpath("//input[@type='radio'][@id='nobel_prize_winners_filter_category_Peace'][@value='Peace']")
    end
    it 'selects an choice from the params when the collection is a nested array' do
      visit '/filters/radio_from_nested_array?nobel_prize_winners[filter][category]=Peace'
      page.should have_xpath("//input[@type='radio'][@id='nobel_prize_winners_filter_category_Peace'][@value='Peace'][@checked='checked']")
    end
  end
end
