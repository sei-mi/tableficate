require 'rails/all'
require 'tablificate'

describe Tablificate::SelectFilter do
  it 'should find the correct template type' do
    table = Tablificate::Table.new(nil, nil, {}, {})
    table.column(:month)

    Tablificate::SelectFilter.new(table, :month, {}).template.should == 'select_filter'
  end
end
