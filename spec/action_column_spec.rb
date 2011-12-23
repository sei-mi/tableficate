require 'spec_helper'

describe Tableficate::ActionColumn do
  before(:all) do
    @action_column = Tableficate::ActionColumn.new(nil) do
      'Actions Here!'
    end
  end

  it 'should always have sorting off ' do
    @action_column.show_sort?.should be false
  end

  it 'should always indicate that it is not sorted' do
    @action_column.is_sorted?.should be false
  end

  it 'should have a blank name' do
    @action_column.name.should == ''
  end

  it 'should accept options' do
    action_column = Tableficate::ActionColumn.new(nil, header: 'Actions') do
      'Actions Here!'
    end

    action_column.header.should == 'Actions'
  end
end
