require 'rails/all'
require 'tablificate/attributes'

describe Tablificate::Attributes do
  it 'should output HTML style attributes with a leading space when to_s is called' do
    attrs = Tablificate::Attributes.new()
    attrs[:id]   = 'table_id'
    attrs[:name] = 'table_name'

    attrs.to_s.should == ' id="table_id" name="table_name"'
  end

  it 'should output an empty string when there are no attributes' do
    attrs = Tablificate::Attributes.new()
    
    attrs.to_s.should == ''
  end
end
