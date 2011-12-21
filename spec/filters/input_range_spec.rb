require 'spec_helper'

describe Tableficate::Filter::InputStart do
  before(:each) do
    template = mock('Template')
    template.stub!(:lookup_context).and_return(ActionView::LookupContext.new([]))
    template.lookup_context.stub!(:exists?).and_return(true)
    @table = Tableficate::Table.new(template, NobelPrizeWinner.joins(:nobel_prizes).limit(1), {}, {})
    @table.column(:year)
    @input_start_filter = Tableficate::Filter::InputStart.new(@table, :year)
  end

  it 'should append "[start]" to field_name' do
    @input_start_filter.field_name == "#{@table.as}[filter][year][start]"
  end

  it 'should append "_start" to the name' do
    @input_start_filter.name == :year_start
  end

  it 'should provide a field value when given params or a blank value' do
    @input_start_filter.field_value({filter: {year: {start: '2011'}}}).should == '2011'
    @input_start_filter.field_value({}).should == ''
  end
end

describe Tableficate::Filter::InputStop do
  before(:each) do
    template = mock('Template')
    template.stub!(:lookup_context).and_return(ActionView::LookupContext.new([]))
    template.lookup_context.stub!(:exists?).and_return(true)
    @table = Tableficate::Table.new(template, NobelPrizeWinner.joins(:nobel_prizes).limit(1), {}, {})
    @table.column(:year)
    @input_stop_filter = Tableficate::Filter::InputStop.new(@table, :year)
  end

  it 'should append "[stop]" to field_name' do
    @input_stop_filter.field_name == "#{@table.as}[filter][year][stop]"
  end

  it 'should append "_stop" to the name' do
    @input_stop_filter.name == :year_stop
  end

  it 'should provide a field value when given params or a blank value' do
    @input_stop_filter.field_value({filter: {year: {stop: '2011'}}}).should == '2011'
    @input_stop_filter.field_value({}).should == ''
  end
end

describe Tableficate::Filter::InputRange do
  before(:each) do
    template = mock('Template')
    template.stub!(:lookup_context).and_return(ActionView::LookupContext.new([]))
    @table = Tableficate::Table.new(template, NobelPrizeWinner.joins(:nobel_prizes).limit(1), {}, {})
    @table.column(:year)
  end

  it 'should create a start and stop input' do
    @table.template.lookup_context.stub!(:exists?).and_return(true)

    filter = Tableficate::Filter::InputRange.new(@table, :year)

    filter.start.is_a?(Tableficate::Filter::InputStart).should be true
    filter.stop.is_a?(Tableficate::Filter::InputStop).should be true
  end

  it 'should use the :start and :stop option hashes for the individual filters and default any values not passed to the range options provided' do
    @table.template.lookup_context.stub!(:exists?).and_return(true)

    filter = Tableficate::Filter::InputRange.new(@table, :year, label: 'Nobel Prize Won In')
    filter.start.label.should == 'Nobel Prize Won In'
    filter.stop.label.should == 'Nobel Prize Won In'

    filter = Tableficate::Filter::InputRange.new(@table, :year, label: 'Nobel Prize Won In', start: {label: 'Nobel Prize Won Between'}, stop: {label: 'and'})
    filter.start.label.should == 'Nobel Prize Won Between'
    filter.stop.label.should == 'and'
  end

  it 'should look for a partial based on the input range type and use it if found' do
    @table.template.lookup_context.stub(:exists?).and_return(true)

    Tableficate::Filter::InputRange.new(@table, :year, type: 'search').template.should == 'filters/input_range_search'
  end

  it 'should look for a partial based on the input range type and use the default if it is not found' do
    @table.template.lookup_context.should_receive(:exists?) do |*args|
      (args.first == 'tableficate/filters/input_range' or args.first == 'tableficate/filters/input')
    end.at_least(:once)

    Tableficate::Filter::InputRange.new(@table, :year, type: 'search').template.should == 'filters/input_range'
  end
end
