require 'spec_helper'

describe Tableficate::Finder do
  it 'should filter based on single input passed in' do
    # exact input
    npw = NobelPrizeWinner.tableficate({filter: {first_name: 'Albert'}})
    npw.size.should == 1
    npw.first.first_name.should == 'Albert'
    npw = NobelPrizeWinner.tableficate({filter: {first_name: 'Al'}})
    npw.size.should == 0
  end

  it 'should filter based on multiple inputs passed in' do
    npw = NobelPrizeWinner.tableficate({filter: {first_name: ['Albert', 'Marie']}})
    npw.size.should == 2
    npw.first.first_name.should == 'Albert'
    npw.last.first_name.should == 'Marie'
    npw = NobelPrizeWinner.tableficate({filter: {first_name: ['Al', 'Mar']}})
    npw.size.should == 0
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
end
