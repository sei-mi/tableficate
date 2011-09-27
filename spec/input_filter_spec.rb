require 'rails/all'
require 'tablificate'

describe Tablificate::InputFilter do
  it 'should find the correct template type' do
    table = Tablificate::Table.new(nil, nil, {}, {})
    table.column(:first_name)

    Tablificate::InputFilter.new(table, :first_name).template.should == 'input_filter'
  end

  it 'should default to the "text" type of input' do
    Tablificate::InputFilter.new(nil, :first_name, label: 'First').attributes[:type].should == 'text'
  end
end
