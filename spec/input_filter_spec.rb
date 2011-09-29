require 'rails/all'
require 'tableficate'

describe Tableficate::InputFilter do
  before(:all) do
    @table = Tableficate::Table.new(nil, nil, {}, {})
  end

  it 'should find the correct template type' do
    Tableficate::InputFilter.new(@table, :first_name, label: 'First').template.should == 'input_filter'
  end

  it 'should use a template based on the type if one exists' do
    Tableficate::InputFilter.new(@table, :first_name, label: 'First', type: 'email').template.should == 'input_filter'

    file = File.open('app/views/tableficate/_email_input_filter.html.erb', 'w')
    Tableficate::InputFilter.new(@table, :first_name, label: 'First', type: 'email').template.should == 'email_input_filter'
    File.delete(file.path)

    file = File.open('app/views/tableficate/_email_input_filter.html.haml', 'w')
    Tableficate::InputFilter.new(@table, :first_name, label: 'First', type: 'email').template.should == 'email_input_filter'
    File.delete(file.path)
  end

  it 'should default to the "text" type of input' do
    Tableficate::InputFilter.new(@table, :first_name, label: 'First').attributes[:type].should == 'text'
  end
end
