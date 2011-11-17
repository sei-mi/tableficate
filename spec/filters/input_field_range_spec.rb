require 'spec_helper'

describe Tableficate::Filter::InputFieldStart do
  before(:all) do
    @table = Tableficate::Table.new(nil, NobelPrizeWinner.joins(:nobel_prizes).limit(1), {}, {})
    @table.column(:year)
  end

  it 'should append "[start]" to field_name' do
    Tableficate::Filter::InputFieldStart.new(@table, :year).field_name == "#{@table.as}[filter][year][start]"
  end

  it 'should append "_start" to the name' do
    Tableficate::Filter::InputFieldStart.new(@table, :year).name == :year_start
  end

  it 'should provide a field value when given params or a blank value' do
    Tableficate::Filter::InputFieldStart.new(@table, :year).field_value({filter: {year: {start: '2011'}}}).should == '2011'
    Tableficate::Filter::InputFieldStart.new(@table, :year).field_value({}).should == ''
  end
end

describe Tableficate::Filter::InputFieldStop do
  before(:all) do
    @table = Tableficate::Table.new(nil, NobelPrizeWinner.joins(:nobel_prizes).limit(1), {}, {})
    @table.column(:year)
  end

  it 'should append "[stop]" to field_name' do
    Tableficate::Filter::InputFieldStop.new(@table, :year).field_name == "#{@table.as}[filter][year][stop]"
  end

  it 'should append "_stop" to the name' do
    Tableficate::Filter::InputFieldStop.new(@table, :year).name == :year_stop
  end

  it 'should provide a field value when given params or a blank value' do
    Tableficate::Filter::InputFieldStop.new(@table, :year).field_value({filter: {year: {stop: '2011'}}}).should == '2011'
    Tableficate::Filter::InputFieldStop.new(@table, :year).field_value({}).should == ''
  end
end

describe Tableficate::Filter::InputFieldRange do
  before(:all) do
    @table = Tableficate::Table.new(nil, NobelPrizeWinner.joins(:nobel_prizes).limit(1), {}, {})
    @table.column(:year)
  end

  it 'should create a start and stop input' do
    filter = Tableficate::Filter::InputFieldRange.new(@table, :year)

    filter.start.is_a?(Tableficate::Filter::InputFieldStart).should be true
    filter.stop.is_a?(Tableficate::Filter::InputFieldStop).should be true
  end

  it 'should use the :start and :stop option hashes for the individual filters and default any values not passed to the range options provided' do
    filter = Tableficate::Filter::InputFieldRange.new(@table, :year, label: 'Nobel Prize Won In')
    filter.start.label.should == 'Nobel Prize Won In'
    filter.stop.label.should == 'Nobel Prize Won In'

    filter = Tableficate::Filter::InputFieldRange.new(@table, :year, label: 'Nobel Prize Won In', start: {label: 'Nobel Prize Won Between'}, stop: {label: 'and'})
    filter.start.label.should == 'Nobel Prize Won Between'
    filter.stop.label.should == 'and'
  end
end
