require 'spec_helper'

describe Tableficate::Filter::SelectStart do
  before(:each) do
    template = mock('Template')
    template.stub!(:lookup_context).and_return(ActionView::LookupContext.new([]))
    template.lookup_context.stub!(:exists?).and_return(true)
    @table = Tableficate::Table.new(template, NobelPrizeWinner.joins(:nobel_prizes).limit(1), {}, {})
    @table.column(:year)
    @select_start_filter = Tableficate::Filter::SelectStart.new(@table, :year, collection: 1900..2000)
  end

  it 'should append "[start]" to field_name' do
    @select_start_filter.field_name == "#{@table.as}[filter][year][start]"
  end

  it 'should append "_start" to the name' do
    @select_start_filter.name == :year_start
  end

  it 'should provide a field value when given params or a blank value' do
    @select_start_filter.field_value({filter: {year: {start: '1911'}}}).should == '1911'
    @select_start_filter.field_value({}).should == ''
  end
end

describe Tableficate::Filter::SelectStop do
  before(:each) do
    template = mock('Template')
    template.stub!(:lookup_context).and_return(ActionView::LookupContext.new([]))
    template.lookup_context.stub!(:exists?).and_return(true)
    @table = Tableficate::Table.new(template, NobelPrizeWinner.joins(:nobel_prizes).limit(1), {}, {})
    @table.column(:year)
    @select_stop_filter = Tableficate::Filter::SelectStop.new(@table, :year, collection: 1900..2000)
  end

  it 'should append "[stop]" to field_name' do
    @select_stop_filter.field_name == "#{@table.as}[filter][year][stop]"
  end

  it 'should append "_stop" to the name' do
    @select_stop_filter.name == :year_stop
  end

  it 'should provide a field value when given params or a blank value' do
    @select_stop_filter.field_value({filter: {year: {stop: '1911'}}}).should == '1911'
    @select_stop_filter.field_value({}).should == ''
  end
end

describe Tableficate::Filter::SelectRange do
  before(:each) do
    template = mock('Template')
    template.stub!(:lookup_context).and_return(ActionView::LookupContext.new([]))
    @table = Tableficate::Table.new(template, NobelPrizeWinner.joins(:nobel_prizes).limit(1), {}, {})
    @table.column(:year)
  end

  it 'should create a start and stop select' do
    @table.template.lookup_context.stub!(:exists?).and_return(true)

    filter = Tableficate::Filter::SelectRange.new(@table, :year, collection: 1900..2000)

    filter.start.is_a?(Tableficate::Filter::SelectStart).should be true
    filter.stop.is_a?(Tableficate::Filter::SelectStop).should be true
  end

  it 'should use the :start and :stop option hashes for the individual filters and default any values not passed to the range options provided' do
    @table.template.lookup_context.stub!(:exists?).and_return(true)

    filter = Tableficate::Filter::SelectRange.new(@table, :year, label: 'Nobel Prize Won In', collection: 1900..2000)
    filter.start.label.should == 'Nobel Prize Won In'
    filter.stop.label.should == 'Nobel Prize Won In'

    filter = Tableficate::Filter::SelectRange.new(@table, :year, label: 'Nobel Prize Won In', start: {label: 'Nobel Prize Won Between'}, stop: {label: 'and'}, collection: 1900..2000)
    filter.start.label.should == 'Nobel Prize Won Between'
    filter.stop.label.should == 'and'
  end
end
