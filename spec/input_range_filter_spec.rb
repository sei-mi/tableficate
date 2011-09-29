require 'rails/all'
require 'tableficate'

describe Tableficate::InputRangeFilter do
  before(:each) do
    @table = Tableficate::Table.new(nil, nil, {}, {})
  end

  it 'should find the correct template type' do
    @table.column(:birth_date)

    Tableficate::InputRangeFilter.new(@table, :birth_date).template.should == 'input_range_filter'
  end

  it 'should create a start input and a stop input' do
    filter = Tableficate::InputRangeFilter.new(@table, :birth_date, label: 'Birthday')

    filter.start.name.should == 'birth_date_start'
    filter.stop.name.should == 'birth_date_stop'

    filter.start.is_a?(Tableficate::InputFilter).should be true
    filter.stop.is_a?(Tableficate::InputFilter).should be true
  end

  it 'should use the label from the range call on the start and stop inputs if they do not already have a label' do
    filter = Tableficate::InputRangeFilter.new(@table, :birth_date, label: 'Birthday')
    filter.start.label.should == 'Birthday'
    filter.stop.label.should == 'Birthday'

    filter = Tableficate::InputRangeFilter.new(@table, :birth_date, label: 'Birthday', start: {label: 'Start'}, stop: {label: 'Stop'})
    filter.start.label.should == 'Start'
    filter.stop.label.should == 'Stop'
  end
end
