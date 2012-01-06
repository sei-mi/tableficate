require 'spec_helper'

describe Tableficate::Finder do
  it 'should filter based on single input passed in' do
    # exact match
    npw = NobelPrizeWinner.tableficate({filter: {first_name: 'Albert'}})
    npw.size.should == 1
    npw.first.first_name.should == 'Albert'
    npw = NobelPrizeWinner.tableficate({filter: {first_name: 'Al'}})
    npw.size.should == 0

    # contains match
    class ContainsNobelPrizeWinner < Tableficate::Base
      scope :nobel_prize_winner

      filter(:first_name, match: :contains)
    end
    npw = ContainsNobelPrizeWinner.tableficate({filter: {first_name: 'Al'}})
    npw.size.should == 1
    npw.first.first_name.should == 'Albert'
  end

  it 'should filter based on multiple inputs passed in' do
    # exact match
    npw = NobelPrizeWinner.tableficate({filter: {first_name: ['Albert', 'Marie']}})
    npw.size.should == 2
    npw.first.first_name.should == 'Albert'
    npw.last.first_name.should == 'Marie'
    npw = NobelPrizeWinner.tableficate({filter: {first_name: ['Al', 'Mar']}})
    npw.size.should == 0

    # contains match
    class ContainsNobelPrizeWinner < Tableficate::Base
      scope :nobel_prize_winner

      filter(:first_name, match: :contains)
    end
    npw = ContainsNobelPrizeWinner.tableficate({filter: {first_name: ['Al', 'Mar']}})
    npw.size.should == 2
    npw.first.first_name.should == 'Albert'
    npw.last.first_name.should == 'Marie'
  end

  it 'should attach the table name to the fields from the primary table to avoid ambiguity' do
    npw = NobelPrizeWinner.joins(:nobel_prizes).tableficate({sort: 'first_name'})
    npw.order_values.should == ["#{npw.table_name}.first_name ASC"]

    # secondary table fields are left vague for maximum flexibility
    npw = NobelPrizeWinner.joins(:nobel_prizes).tableficate({sort: 'year'})
    npw.order_values.should == ["year ASC"]
  end

  it 'should allow ranged input filters' do
    np = NobelPrize.tableficate({filter: {year: {start: 1900, stop: 1930}}})
    np.size.should == 4
  end

  it 'should remove harmful characters from the param name' do
    np = NobelPrize.tableficate({filter: {"ye'ar" =>  {start: 1900, stop: 1930}}})
    np.size.should == 4
  end

  it 'should handle a date string being used against a datetime or timestamp column' do
    np = NobelPrizeWinner.tableficate({filter: {created_at: '20110101'}})
    np.size.should == 1
  end

  it 'should handle a date range being used against a datetime or timestamp column' do
    np = NobelPrizeWinner.tableficate({filter: {created_at: {start: '20110101', stop: '20110105'}}})
    np.size.should == 5
  end

  it 'should match an exact datetime and account for the timezone setting' do
    np = NobelPrizeWinner.tableficate({filter: {created_at: '20110101050112'}})
    np.size.should == 1
  end

  it 'should match an exact datetime range and account for the timezone setting' do
    np = NobelPrizeWinner.tableficate({filter: {created_at: {start: '20110101050112', stop: '20110102050212'}}})
    np.size.should == 2
  end
end
