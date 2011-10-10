require 'spec_helper'

describe Tableficate::SelectFilter do
  it 'should find the correct template type' do
    table = Tableficate::Table.new(nil, NobelPrizeWinner.joins(:nobel_prizes).limit(1), {}, {})
    table.column(:year)

    Tableficate::SelectFilter.new(table, :year, []).template.should == 'select_filter'
  end
end
