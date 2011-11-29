require 'spec_helper'
include Tableficate::Helper

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
    it 'selects an option from the params when the collection is a hash' do
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

  describe 'tableficate_radio_tags' do
    it 'takes a block for custom output' do
      visit '/filters/radio_tags?theme=custom_radio_block'
    end

    it 'should display a group of radio tags with no selection and nothing filtered' do
      visit '/filters/radio_tags'

      ['Chemistry', 'Literature', 'Peace', 'Physics', 'Physiology or Medicine'].each do |category|
        id = "nobel_prize_winners_filter_category_#{category.gsub(/ /, '_')}"

        page.should have_xpath("//input[@type='radio'][@id='#{id}'][@value='#{category}']")

        page.has_no_checked_field?(id).should be true
      end

      page.should have_xpath('//table/tbody/tr', count: NobelPrizeWinner.joins(:nobel_prizes).size)
    end

    it 'should display a group of radio tags with a selection and the table filtered' do
      selected_category = 'Peace'
      visit "/filters/radio_tags?nobel_prize_winners[filter][category]=#{selected_category}"

      ['Chemistry', 'Literature', 'Peace', 'Physics', 'Physiology or Medicine'].each do |category|
        id = "nobel_prize_winners_filter_category_#{category.gsub(/ /, '_')}"

        page.should have_xpath("//input[@type='radio'][@id='#{id}'][@value='#{category}']")

        if category == selected_category
          page.has_checked_field?(id).should be true
        else
          page.has_no_checked_field?(id).should be true
        end
      end

      page.should have_xpath('//table/tbody/tr', count: NobelPrizeWinner.joins(:nobel_prizes).where('nobel_prizes.category = ?', selected_category).size)
    end
  end
end
