require 'rails/all'
require 'tableficate'

describe Tableficate::SelectFilter do
  it 'should find the correct template type' do
    table = Tableficate::Table.new(nil, nil, {}, {})
    table.column(:month)

    Tableficate::SelectFilter.new(table, :month, {}).template.should == 'select_filter'
  end
end
