require 'rails/all'
require 'tableficate'

describe Tableficate::Filter do
  it 'should find the correct template type' do
    table = Tableficate::Table.new(nil, nil, {}, {})
    table.column(:first_name)

    Tableficate::Filter.new(table, :first_name).template.should == 'filter'
  end

  it 'should use the provided label or default to the column header' do
    table = Tableficate::Table.new(nil, nil, {}, {})
    table.column(:first_name)
    table.column(:last_name, header: 'Last')

    Tableficate::Filter.new(table, :first_name).label.should == 'First Name'
    Tableficate::Filter.new(table, :last_name).label.should == 'Last'
  end
end
