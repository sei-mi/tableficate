require 'spec_helper'

describe Tableficate::Table do
  before(:each) do
    @table = Tableficate::Table.new(nil, NobelPrizeWinner.limit(1), {}, {current_sort: {column: :first_name, dir: 'asc'}})
  end

  it 'should have the current sort if provided' do
    @table.current_sort.should == {column: :first_name, dir: 'asc'}
  end

  it 'should use the :as option or default to the table_name of the scope' do
    Tableficate::Table.new(nil, NobelPrizeWinner.limit(1), {as: 'npw'}, {}).as.should == 'npw'
    @table.as.should == 'nobel_prize_winners'
  end

  it 'should add a Column' do
    @table.column(:first_name)
    @table.column(:last_name)

    @table.columns.first.name.should == :first_name
    @table.columns.first.is_a?(Tableficate::Column).should be true
    @table.columns.last.name.should == :last_name
  end

  it 'should indicate that it is sortble if any column is sortable' do
    @table.column(:first_name)
    @table.show_sort?.should be false

    @table.column(:last_name, show_sort: true)
    @table.show_sort?.should be true
  end

  it 'should overwrite the column sorting unless it is provided' do
    @table.column(:first_name)
    @table.column(:last_name, show_sort: true)

    @table.columns.first.show_sort?.should be false
    @table.columns.last.show_sort?.should be true

    table = Tableficate::Table.new(nil, NobelPrizeWinner.limit(1), {show_sorts: true}, {})
    table.column(:first_name)
    table.column(:last_name, show_sort: false)

    table.columns.first.show_sort?.should be true
    table.columns.last.show_sort?.should be false
  end

  it 'should add an ActionColumn' do
    @table.actions do
      Action!
    end

    @table.columns.first.is_a?(Tableficate::ActionColumn).should be true
  end

  it 'should determine whether any columns are sortable' do
    @table.column(:first_name, show_sort: true)

    @table.show_sort?.should be true

    table = Tableficate::Table.new(nil, NobelPrizeWinner.limit(1), {show_sorts: true}, {})
    table.column(:first_name, show_sort: false)

    table.show_sort?.should be false
  end

  it 'should add an InputFilter' do
    @table.input_filter(:first_name, label: 'First')
    @table.input_filter(:last_name, label: 'Last')

    @table.filters.first.name.should == :first_name
    @table.filters.first.is_a?(Tableficate::InputFilter).should be true
    @table.filters.last.name.should == :last_name
  end

  it 'should add an InputRangeFilter' do
    @table.input_range_filter(:first_name, label: 'First')
    @table.input_range_filter(:last_name, label: 'Last')

    @table.filters.first.name.should == :first_name
    @table.filters.first.is_a?(Tableficate::InputRangeFilter).should be true
    @table.filters.last.name.should == :last_name
  end

  it 'should add an SelectFilter' do
    @table.select_filter(:first_name, {}, label: 'First')
    @table.select_filter(:last_name, {}, label: 'Last')

    @table.filters.first.name.should == :first_name
    @table.filters.first.is_a?(Tableficate::SelectFilter).should be true
    @table.filters.last.name.should == :last_name
  end
end
