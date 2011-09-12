require 'rails'
require 'tablificate/column'

describe Tablificate::Column do
  it 'should generate a header if none is provided' do
    column = Tablificate::Column.new(:first_name)
    column.header.should == 'First Name'
  end
  it 'should show the header if provided' do
    column = Tablificate::Column.new(:user_id, header: 'User')
    column.header.should == 'User'
  end
end
