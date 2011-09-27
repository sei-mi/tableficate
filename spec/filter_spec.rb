require 'rails/all'
require 'tablificate'

describe Tablificate::Filter do
  it 'should find the correct template type' do
    table = Tablificate::Table.new(nil, nil, {}, {})
    table.column(:first_name)

    Tablificate::Filter.new(table, :first_name).template.should == 'filter'
  end

  it 'should use the provided label or default to the column header' do
    table = Tablificate::Table.new(nil, nil, {}, {})
    table.column(:first_name)
    table.column(:last_name, header: 'Last')

    Tablificate::Filter.new(table, :first_name).label.should == 'First Name'
    Tablificate::Filter.new(table, :last_name).label.should == 'Last'
  end
end
