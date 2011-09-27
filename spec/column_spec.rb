require 'rails/all'
require 'tablificate'

describe Tablificate::Column do
  it 'should generate a header if none is provided' do
    column = Tablificate::Column.new(nil, :first_name)

    column.header.should == 'First Name'
  end
  it 'should show the header if provided' do
    column = Tablificate::Column.new(nil, :school, header: 'Alma Mater')

    column.header.should == 'Alma Mater'
  end

  it 'should show the value from the database field if no alternative is provided' do
    row = mock('Agronomist')
    row.stub!(:name).and_return('Norman Borlaug')

    column = Tablificate::Column.new(nil, :name)

    column.value(row).should == 'Norman Borlaug'
  end
  it 'should return the value provided from the block' do
    row = mock('Agronomist')
    row.stub!(:birthdate).and_return(Time.utc(1914, 3, 25, 13, 45, 37))

    column = Tablificate::Column.new(nil, :born_at) do |row|
      row.birthdate.strftime('%B %d, %Y at %I:%M:%S %P')
    end

    column.value(row).should == 'March 25, 1914 at 01:45:37 pm'
  end

  it 'should allow sorting to be turned on and off' do
    column = Tablificate::Column.new(nil, :first_name, show_sort: false)
    column.show_sort?.should be false

    column = Tablificate::Column.new(nil, :first_name, show_sort: true)
    column.show_sort?.should be true

    column = Tablificate::Column.new(nil, :first_name)
    column.show_sort?.should be false
  end

  it 'should indicate whether a column is sorted or not' do
    table = Tablificate::Table.new(nil, [], {}, {current_sort: {column: :first_name, dir: 'asc'}})

    column = Tablificate::Column.new(table, :first_name)
    column.is_sorted?('asc').should be true

    column = Tablificate::Column.new(table, :first_name)
    column.is_sorted?('desc').should be false

    column = Tablificate::Column.new(table, :first_name)
    column.is_sorted?.should be true

    column = Tablificate::Column.new(table, :last_name)
    column.is_sorted?.should be false
  end
end
