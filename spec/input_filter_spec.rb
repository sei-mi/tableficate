require 'rails/all'
require 'tablificate'

describe Tablificate::InputFilter do
  before(:all) do
    @table = Tablificate::Table.new(nil, nil, {}, {})
  end

  it 'should find the correct template type' do
    Tablificate::InputFilter.new(@table, :first_name, label: 'First').template.should == 'input_filter'
  end

  it 'should use a template based on the type if one exists' do
    Tablificate::InputFilter.new(@table, :first_name, label: 'First', type: 'email').template.should == 'input_filter'

    file = File.open('app/views/tablificate/_email_input_filter.html.erb', 'w')
    Tablificate::InputFilter.new(@table, :first_name, label: 'First', type: 'email').template.should == 'email_input_filter'
    File.delete(file.path)

    file = File.open('app/views/tablificate/_email_input_filter.html.haml', 'w')
    Tablificate::InputFilter.new(@table, :first_name, label: 'First', type: 'email').template.should == 'email_input_filter'
    File.delete(file.path)
  end

  it 'should default to the "text" type of input' do
    Tablificate::InputFilter.new(@table, :first_name, label: 'First').attributes[:type].should == 'text'
  end
end
