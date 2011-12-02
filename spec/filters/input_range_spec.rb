require 'spec_helper'

describe Tableficate::Filter::InputStart do
  before(:each) do
    template = mock('Template')
    template.stub!(:lookup_context).and_return(ActionView::LookupContext.new([]))
    template.lookup_context.stub!(:exists?).and_return(true)
    @table = Tableficate::Table.new(template, NobelPrizeWinner.joins(:nobel_prizes).limit(1), {}, {})
    @table.column(:year)
  end

  it 'should append "[start]" to field_name' do
    Tableficate::Filter::InputStart.new(@table, :year).field_name == "#{@table.as}[filter][year][start]"
  end

  it 'should append "_start" to the name' do
    Tableficate::Filter::InputStart.new(@table, :year).name == :year_start
  end

  it 'should provide a field value when given params or a blank value' do
    Tableficate::Filter::InputStart.new(@table, :year).field_value({filter: {year: {start: '2011'}}}).should == '2011'
    Tableficate::Filter::InputStart.new(@table, :year).field_value({}).should == ''
  end
end

describe Tableficate::Filter::InputStop do
  before(:each) do
    template = mock('Template')
    template.stub!(:lookup_context).and_return(ActionView::LookupContext.new([]))
    template.lookup_context.stub!(:exists?).and_return(true)
    @table = Tableficate::Table.new(template, NobelPrizeWinner.joins(:nobel_prizes).limit(1), {}, {})
    @table.column(:year)
  end

  it 'should append "[stop]" to field_name' do
    Tableficate::Filter::InputStop.new(@table, :year).field_name == "#{@table.as}[filter][year][stop]"
  end

  it 'should append "_stop" to the name' do
    Tableficate::Filter::InputStop.new(@table, :year).name == :year_stop
  end

  it 'should provide a field value when given params or a blank value' do
    Tableficate::Filter::InputStop.new(@table, :year).field_value({filter: {year: {stop: '2011'}}}).should == '2011'
    Tableficate::Filter::InputStop.new(@table, :year).field_value({}).should == ''
  end
end

describe Tableficate::Filter::InputRange do
  before(:each) do
    template = mock('Template')
    template.stub!(:lookup_context).and_return(ActionView::LookupContext.new([]))
    template.lookup_context.stub!(:exists?).and_return(true)
    @table = Tableficate::Table.new(template, NobelPrizeWinner.joins(:nobel_prizes).limit(1), {}, {})
    @table.column(:year)
  end

  it 'should create a start and stop input' do
    filter = Tableficate::Filter::InputRange.new(@table, :year)

    filter.start.is_a?(Tableficate::Filter::InputStart).should be true
    filter.stop.is_a?(Tableficate::Filter::InputStop).should be true
  end

  it 'should use the :start and :stop option hashes for the individual filters and default any values not passed to the range options provided' do
    filter = Tableficate::Filter::InputRange.new(@table, :year, label: 'Nobel Prize Won In')
    filter.start.label.should == 'Nobel Prize Won In'
    filter.stop.label.should == 'Nobel Prize Won In'

    filter = Tableficate::Filter::InputRange.new(@table, :year, label: 'Nobel Prize Won In', start: {label: 'Nobel Prize Won Between'}, stop: {label: 'and'})
    filter.start.label.should == 'Nobel Prize Won Between'
    filter.stop.label.should == 'and'
  end
end
