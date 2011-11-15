require 'spec_helper'

describe Tableficate::InputFilter do
  before(:all) do
    @table = Tableficate::Table.new(nil, NobelPrizeWinner.joins(:nobel_prizes).limit(1), {}, {})
    @table.column(:first_name)
  end

  it 'should find the correct template type' do
    Tableficate::InputFilter.new(@table, :first_name).template.should == 'input_filter'

    Tableficate::InputFilter.new(@table, :first_name, field_options: {type: 'email'}).template.should == 'input_filter'

    file = File.open('app/views/tableficate/_email_input_filter.html.erb', 'w')
    Tableficate::InputFilter.new(@table, :first_name, field_options: {type: 'email'}).template.should == 'email_input_filter'
    File.delete(file.path)

    file = File.open('app/views/tableficate/_email_input_filter.html.haml', 'w')
    Tableficate::InputFilter.new(@table, :first_name, field_options: {type: 'email'}).template.should == 'email_input_filter'
    File.delete(file.path)
  end
end

describe Tableficate::InputStartFilter do
  before(:all) do
    @table = Tableficate::Table.new(nil, NobelPrizeWinner.joins(:nobel_prizes).limit(1), {}, {})
    @table.column(:year)
  end

  it 'should append "[start]" to field_name' do
    Tableficate::InputStartFilter.new(@table, :year).field_name == "#{@table.as}[filter][year][start]"
  end

  it 'should append "_start" to the name' do
    Tableficate::InputStartFilter.new(@table, :year).name == :year_start
  end

  it 'should provide a field value when given params or a blank value' do
    Tableficate::InputStartFilter.new(@table, :year).field_value({filter: {year: {start: '2011'}}}).should == '2011'
    Tableficate::InputStartFilter.new(@table, :year).field_value({}).should == ''
  end
end

describe Tableficate::InputStopFilter do
  before(:all) do
    @table = Tableficate::Table.new(nil, NobelPrizeWinner.joins(:nobel_prizes).limit(1), {}, {})
    @table.column(:year)
  end

  it 'should append "[stop]" to field_name' do
    Tableficate::InputStopFilter.new(@table, :year).field_name == "#{@table.as}[filter][year][stop]"
  end

  it 'should append "_stop" to the name' do
    Tableficate::InputStopFilter.new(@table, :year).name == :year_stop
  end

  it 'should provide a field value when given params or a blank value' do
    Tableficate::InputStopFilter.new(@table, :year).field_value({filter: {year: {stop: '2011'}}}).should == '2011'
    Tableficate::InputStopFilter.new(@table, :year).field_value({}).should == ''
  end
end

describe Tableficate::InputRangeFilter do
  before(:all) do
    @table = Tableficate::Table.new(nil, NobelPrizeWinner.joins(:nobel_prizes).limit(1), {}, {})
    @table.column(:year)
  end

  it 'should find the correct template type' do
    Tableficate::InputRangeFilter.new(@table, :year).template.should == 'input_range_filter'
  end

  it 'should create a start and stop input' do
    filter = Tableficate::InputRangeFilter.new(@table, :year)

    filter.start.is_a?(Tableficate::InputStartFilter).should be true
    filter.stop.is_a?(Tableficate::InputStopFilter).should be true
  end

  it 'should use the :start and :stop option hashes for the individual filters and default any values not passed to the range options provided' do
    filter = Tableficate::InputRangeFilter.new(@table, :year, label: 'Nobel Prize Won In')
    filter.start.label.should == 'Nobel Prize Won In'
    filter.stop.label.should == 'Nobel Prize Won In'

    filter = Tableficate::InputRangeFilter.new(@table, :year, label: 'Nobel Prize Won In', start: {label: 'Nobel Prize Won Between'}, stop: {label: 'and'})
    filter.start.label.should == 'Nobel Prize Won Between'
    filter.stop.label.should == 'and'
  end
end
