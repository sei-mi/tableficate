require 'rails/all'
require 'tablificate'

describe Tablificate::InputRangeFilter do
  it 'should find the correct template type' do
    table = Tablificate::Table.new(nil, nil, {}, {})
    table.column(:birth_date)

    Tablificate::InputRangeFilter.new(table, :birth_date).template.should == 'input_range_filter'
  end

  it 'should create a start input and a stop input' do
    filter = Tablificate::InputRangeFilter.new(nil, :birth_date, label: 'Birthday')

    filter.start.name.should == 'birth_date_start'
    filter.stop.name.should == 'birth_date_stop'

    filter.start.is_a?(Tablificate::InputFilter).should be true
    filter.stop.is_a?(Tablificate::InputFilter).should be true
  end

  it 'should use the label from the range call on the start and stop inputs if they do not already have a label' do
    filter = Tablificate::InputRangeFilter.new(nil, :birth_date, label: 'Birthday')
    filter.start.label.should == 'Birthday'
    filter.stop.label.should == 'Birthday'

    filter = Tablificate::InputRangeFilter.new(nil, :birth_date, label: 'Birthday', start: {label: 'Start'}, stop: {label: 'Stop'})
    filter.start.label.should == 'Start'
    filter.stop.label.should == 'Stop'
  end
end
