require 'rails/all'
require 'tableficate/attributes'

describe Tableficate::Attributes do
  it 'should output HTML style attributes with a leading space when to_s is called' do
    attrs = Tableficate::Attributes.new()
    attrs[:id]   = 'table_id'
    attrs[:name] = 'table_name'

    attrs.to_s.should == ' id="table_id" name="table_name"'
  end

  it 'should output an empty string when there are no attributes' do
    attrs = Tableficate::Attributes.new()
    
    attrs.to_s.should == ''
  end
end
