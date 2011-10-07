require 'spec_helper'

describe 'Tableficate::ActiveRecordExtention' do
  it 'should add and retreive data from the scope' do
    scope = NobelPrizeWinner.tableficate_ext
    scope.tableficate_add_data(:name, 'Aaron')
    scope.tableficate_get_data.should == {name: 'Aaron'}
  end
end
