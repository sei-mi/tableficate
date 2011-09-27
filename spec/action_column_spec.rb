require 'rails/all'
require 'tablificate'

describe Tablificate::ActionColumn do
  before(:all) do
    @action_column = Tablificate::ActionColumn.new(nil, nil) do
      Actions!
    end
  end

  it 'should always have sorting off ' do
    @action_column.show_sort?.should be false
  end

  it 'should always indicate that it is not sorted' do
    @action_column.is_sorted?.should be false
  end
end
