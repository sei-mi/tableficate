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

    it 'should display a multi select box from a string' do
      visit '/filters/multi_select_from_string'

      ['Chemistry', 'Literature', 'Peace', 'Physics', 'Physiology or Medicine'].each do |category|
        page.should have_xpath("//select[@id='nobel_prize_winners_filter_category']/option[text()='#{category}']")
        page.should have_no_xpath("//select[@id='nobel_prize_winners_filter_category']/option[text()='#{category}'][@selected='selected']")
      end
    end

    it 'should display a multi select box and select an option' do
      visit '/filters/multi_select_from_string?nobel_prize_winners[filter][category][]=Peace&nobel_prize_winners[filter][category][]=Literature'

      ['Chemistry', 'Literature', 'Peace', 'Physics', 'Physiology or Medicine'].each do |category|
        page.should have_xpath("//select[@id='nobel_prize_winners_filter_category']/option[text()='#{category}']")
        if category == 'Peace' or category == 'Literature'
          page.should have_xpath("//select[@id='nobel_prize_winners_filter_category']/option[text()='#{category}'][@selected='selected']")
        else
          page.should have_no_xpath("//select[@id='nobel_prize_winners_filter_category']/option[text()='#{category}'][@selected='selected']")
        end
      end
    end

    it 'should display a select box' do
      visit '/filters/select_tag'

      ['Chemistry', 'Literature', 'Peace', 'Physics', 'Physiology or Medicine'].each do |category|
        page.should have_xpath("//select[@id='nobel_prize_winners_filter_category']/option[@value='#{category}']")
        page.should have_no_xpath("//select[@id='nobel_prize_winners_filter_category']/option[@value='#{category}'][@selected='selected']")
      end
    end

    it 'should display a select box and select an option' do
      visit '/filters/select_tag?nobel_prize_winners[filter][category]=Peace'

      ['Chemistry', 'Literature', 'Peace', 'Physics', 'Physiology or Medicine'].each do |category|
        page.should have_xpath("//select[@id='nobel_prize_winners_filter_category']/option[@value='#{category}']")
        if category == 'Peace'
          page.should have_xpath("//select[@id='nobel_prize_winners_filter_category']/option[@value='#{category}'][@selected='selected']")
        else
          page.should have_no_xpath("//select[@id='nobel_prize_winners_filter_category']/option[@value='#{category}'][@selected='selected']")
        end
      end
    end

    it 'should display a multi select box' do
      visit '/filters/multi_select_tag'

      ['Chemistry', 'Literature', 'Peace', 'Physics', 'Physiology or Medicine'].each do |category|
        page.should have_xpath("//select[@id='nobel_prize_winners_filter_category']/option[@value='#{category}']")
        page.should have_no_xpath("//select[@id='nobel_prize_winners_filter_category']/option[@value='#{category}'][@selected='selected']")
      end
    end

    it 'should display a select box and select an option' do
      visit '/filters/multi_select_tag?nobel_prize_winners[filter][category][]=Peace&nobel_prize_winners[filter][category][]=Literature'

      ['Chemistry', 'Literature', 'Peace', 'Physics', 'Physiology or Medicine'].each do |category|
        page.should have_xpath("//select[@id='nobel_prize_winners_filter_category']/option[@value='#{category}']")
        if category == 'Peace' or category == 'Literature'
          page.should have_xpath("//select[@id='nobel_prize_winners_filter_category']/option[@value='#{category}'][@selected='selected']")
        else
          page.should have_no_xpath("//select[@id='nobel_prize_winners_filter_category']/option[@value='#{category}'][@selected='selected']")
        end
      end
    end
  end

  describe 'tableficate_radio_tags' do
    it 'allows themes to customize output' do
      visit '/filters/radio_tags?theme=custom_radio_block'

      page.html.should match /<label for="nobel_prize_winners_filter_category_Chemistry">Chemistry<\/label>\s*<input id="nobel_prize_winners_filter_category_Chemistry" name="nobel_prize_winners\[filter\]\[category\]" type="radio" value="Chemistry">/
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

  describe 'tableficate_check_box_tags' do
    it 'allows themes to customize output' do
      visit '/filters/check_box_tags?theme=custom_check_box_block'

      page.html.should match /<label for="nobel_prize_winners_filter_category_Chemistry">Chemistry<\/label>\s*<input id="nobel_prize_winners_filter_category_Chemistry" name="nobel_prize_winners\[filter\]\[category\]\[\]" type="checkbox" value="Chemistry">/
    end

    it 'should display a group of check box tags with no selection and nothing filtered' do
      visit '/filters/check_box_tags'

      ['Chemistry', 'Literature', 'Peace', 'Physics', 'Physiology or Medicine'].each do |category|
        id = "nobel_prize_winners_filter_category_#{category.gsub(/ /, '_')}"

        page.should have_xpath("//input[@type='checkbox'][@id='#{id}'][@value='#{category}']")

        page.has_no_checked_field?(id).should be true
      end

      page.should have_xpath('//table/tbody/tr', count: NobelPrizeWinner.joins(:nobel_prizes).size)
    end

    it 'should display a group of check box tags with a selection and the table filtered' do
      selected_category = 'Peace'
      visit "/filters/check_box_tags?nobel_prize_winners[filter][category]=#{selected_category}"

      ['Chemistry', 'Literature', 'Peace', 'Physics', 'Physiology or Medicine'].each do |category|
        id = "nobel_prize_winners_filter_category_#{category.gsub(/ /, '_')}"

        page.should have_xpath("//input[@type='checkbox'][@id='#{id}'][@value='#{category}']")

        if category == selected_category
          page.has_checked_field?(id).should be true
        else
          page.has_no_checked_field?(id).should be true
        end
      end

      page.should have_xpath('//table/tbody/tr', count: NobelPrizeWinner.joins(:nobel_prizes).where('nobel_prizes.category = ?', selected_category).size)
    end
  end

  describe 'tableficate_hidden_tags' do
    it 'displays hidden tags' do
      visit '/filters/hidden_tags'

      1.upto(2) do |i|
        field = page.find("#nobel_prize_winners_filter_hidden_id_#{i}")
        field[:type].should == 'hidden'
        field.value.should == i.to_s
      end
    end
  end
end
