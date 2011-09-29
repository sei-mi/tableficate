require 'rails/all'
require 'tableficate'

describe Tableficate::Table do
  it 'should have the current sort if provided' do
    table = Tableficate::Table.new(nil, nil, {}, {current_sort: {column: :first_name, dir: 'asc'}})

    table.current_sort.should == {column: :first_name, dir: 'asc'}
  end

  it 'should add a Column' do
    table = Tableficate::Table.new(nil, nil, {}, {})
    table.column :first_name
    table.column :last_name

    table.columns.first.name.should == :first_name
    table.columns.last.name.should == :last_name
  end
  it 'should overwrite the column sorting unless it is provided' do
    table = Tableficate::Table.new(nil, nil, {}, {})
    table.column :first_name
    table.column :last_name, show_sort: true

    table.columns.first.show_sort?.should be false
    table.columns.last.show_sort?.should be true

    table = Tableficate::Table.new(nil, nil, {show_sorts: true}, {})
    table.column :first_name
    table.column :last_name, show_sort: false

    table.columns.first.show_sort?.should be true
    table.columns.last.show_sort?.should be false
  end

  it 'should add an ActionColumn' do
    table = Tableficate::Table.new(nil, nil, {}, {})
    table.actions do
      Action!
    end

    table.columns.first.is_a?(Tableficate::ActionColumn).should be true
  end

  it 'should determine whether any columns are sortable' do
    table = Tableficate::Table.new(nil, nil, {}, {})
    table.column :first_name, show_sort: true

    table.show_sort?.should be true

    table = Tableficate::Table.new(nil, nil, {show_sorts: true}, {})
    table.column :first_name, show_sort: false

    table.show_sort?.should be false
  end

  it 'should add an InputFilter' do
    table = Tableficate::Table.new(nil, nil, {}, {})
    table.input_filter :first_name, label: 'First'
    table.input_filter :last_name, label: 'Last'

    table.filters.first.name.should == :first_name
    table.filters.first.is_a?(Tableficate::InputFilter).should be true
    table.filters.last.name.should == :last_name
  end

  it 'should add an InputRangeFilter' do
    table = Tableficate::Table.new(nil, nil, {}, {})
    table.input_range_filter :first_name, label: 'First'
    table.input_range_filter :last_name, label: 'Last'

    table.filters.first.name.should == :first_name
    table.filters.first.is_a?(Tableficate::InputRangeFilter).should be true
    table.filters.last.name.should == :last_name
  end

  it 'should add an SelectFilter' do
    table = Tableficate::Table.new(nil, nil, {}, {})
    table.select_filter :first_name, {}, label: 'First'
    table.select_filter :last_name, {}, label: 'Last'

    table.filters.first.name.should == :first_name
    table.filters.first.is_a?(Tableficate::SelectFilter).should be true
    table.filters.last.name.should == :last_name
  end
end
