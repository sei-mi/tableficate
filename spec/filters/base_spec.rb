require 'spec_helper'

describe Tableficate::Filter::Base do
  before(:all) do
    @table = Tableficate::Table.new(nil, NobelPrizeWinner.limit(1), {}, {})
    @table.column(:first_name, header: 'Given Name')
    @first_name_filter = Tableficate::Filter::Base.new(@table, :first_name)
  end

  it 'should find the correct template type' do
    @first_name_filter.template.should == 'filters/base'
  end

  it 'should use the provided label or default to the column header' do
    @first_name_filter.label.should == 'Given Name'
    Tableficate::Filter::Base.new(@table, :first_name, label: 'First').label.should == 'First'
  end

  it 'should provide a field name' do
    @first_name_filter.field_name.should == "#{@table.as}[filter][first_name]"
  end

  it 'should provide a field value when given params or a blank value' do
    @first_name_filter.field_value({filter: {first_name: 'Aaron'}}).should == 'Aaron'
    @first_name_filter.field_value({}).should == ''
  end

  it 'should allow for filters that do not match a particular field' do
    Tableficate::Filter::Base.new(@table, :custom_field).label.should == 'Custom Field'
  end
end
