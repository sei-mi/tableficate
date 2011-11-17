require 'spec_helper'

describe Tableficate::Filter::Base do
  before(:all) do
    @table = Tableficate::Table.new(nil, NobelPrizeWinner.limit(1), {}, {})
    @table.column(:first_name, header: 'Given Name')
  end

  it 'should find the correct template type' do
    Tableficate::Filter::Base.new(@table, :first_name).template.should == 'filters/base'
  end

  it 'should use the provided label or default to the column header' do
    Tableficate::Filter::Base.new(@table, :first_name).label.should == 'Given Name'
    Tableficate::Filter::Base.new(@table, :first_name, label: 'First').label.should == 'First'
  end

  it 'should provide a field name' do
    Tableficate::Filter::Base.new(@table, :first_name).field_name.should == "#{@table.as}[filter][first_name]"
  end

  it 'should provide a field value when given params or a blank value' do
    Tableficate::Filter::Base.new(@table, :first_name).field_value({filter: {first_name: 'Aaron'}}).should == 'Aaron'
    Tableficate::Filter::Base.new(@table, :first_name).field_value({}).should == ''
  end

  it 'should allow for filters that do not match a particular field' do
    Tableficate::Filter::Base.new(@table, :custom_field).label.should == 'Custom Field'
  end
end
