require 'spec_helper'

describe Tableficate::Table do
  before(:each) do
    template = mock('Template')
    template.stub!(:lookup_context).and_return(ActionView::LookupContext.new([]))
    template.lookup_context.stub!(:exists?).and_return(true)
    @table = Tableficate::Table.new(template, NobelPrizeWinner.joins(:nobel_prizes).limit(1), {}, {current_sort: {column: :first_name, dir: 'asc'}})
  end

  it 'should have the current sort if provided' do
    @table.current_sort.should == {column: :first_name, dir: 'asc'}
  end

  it 'should use the :as option or default to the table_name of the scope' do
    Tableficate::Table.new(nil, NobelPrizeWinner.limit(1), {as: 'npw'}, {}).as.should == 'npw'
    @table.as.should == 'nobel_prize_winners'
  end

  it 'should add a empty' do
    @table.empty('There is no data.')
    @table.empty.is_a?(Tableficate::Empty).should be true
    @table.empty.value.should == 'There is no data.'

    @table.empty do
      'No data.'
    end
    @table.empty.value.should == 'No data.'
  end

  it 'should add a caption' do
    @table.caption('Nobel Prize Winners')
    @table.caption.is_a?(Tableficate::Caption).should be true
    @table.caption.value.should == 'Nobel Prize Winners'

    @table.caption do
      'Nobel Winners'
    end
    @table.caption.value.should == 'Nobel Winners'
  end

  it 'should add a Column' do
    @table.column(:first_name)
    @table.column(:last_name)

    @table.columns.first.name.should == :first_name
    @table.columns.first.is_a?(Tableficate::Column).should be true
    @table.columns.last.name.should == :last_name
  end

  it 'should indicate that it is sortble if any column is sortable' do
    @table.column(:first_name)
    @table.show_sort?.should be false

    @table.column(:last_name, show_sort: true)
    @table.show_sort?.should be true
  end

  it 'should overwrite the column sorting unless it is provided' do
    @table.column(:first_name)
    @table.column(:last_name, show_sort: true)

    @table.columns.first.show_sort?.should be false
    @table.columns.last.show_sort?.should be true

    table = Tableficate::Table.new(nil, NobelPrizeWinner.limit(1), {show_sorts: true}, {})
    table.column(:first_name)
    table.column(:last_name, show_sort: false)

    table.columns.first.show_sort?.should be true
    table.columns.last.show_sort?.should be false
  end

  it 'should add an ActionColumn' do
    @table.actions do
      Action!
    end

    @table.columns.first.is_a?(Tableficate::ActionColumn).should be true
  end

  it 'should determine whether any columns are sortable' do
    @table.column(:first_name, show_sort: true)

    @table.show_sort?.should be true

    table = Tableficate::Table.new(nil, NobelPrizeWinner.limit(1), {show_sorts: true}, {})
    table.column(:first_name, show_sort: false)

    table.show_sort?.should be false
  end

  it 'should add an Input filter' do
    @table.filter(:first_name, label: 'First')
    @table.filter(:last_name, label: 'Last')

    @table.filters.first.name.should == :first_name
    @table.filters.first.is_a?(Tableficate::Filter::Input).should be true
    @table.filters.last.name.should == :last_name
  end

  it 'should raise an error if Input is passed an unknown type' do
    lambda {@table.filter(:first_name, as: :foo)}.should raise_error(Tableficate::Filter::UnknownInputType)
  end

  it 'should add the Input for known types and pass through the type based on :as' do
    @table.filter(:first_name, as: :search)

    @table.filters.first.is_a?(Tableficate::Filter::Input).should be true
    @table.filters.first.attrs[:type].should == 'search'
  end

  it 'should default the type to "checkbox" for boolean fields' do
    @table.filter(:shared)

    @table.filters.first.is_a?(Tableficate::Filter::CheckBox).should be true
    @table.filters.first.attrs[:type].should == 'checkbox'
  end

  it 'should default the type to "email" for string fields with "email" somewhere in the name' do
    @table.filter(:email)

    @table.filters.first.is_a?(Tableficate::Filter::Input).should be true
    @table.filters.first.attrs[:type].should == 'email'
  end

  it 'should default the type to "url" for string fields with "url" somewhere in the name' do
    @table.filter(:url)

    @table.filters.first.is_a?(Tableficate::Filter::Input).should be true
    @table.filters.first.attrs[:type].should == 'url'
  end

  it 'should default the type to "tel" for string fields with "phone" somewhere in the name' do
    @table.filter(:home_phone)

    @table.filters.first.is_a?(Tableficate::Filter::Input).should be true
    @table.filters.first.attrs[:type].should == 'tel'
  end

  it 'should default the type to "number" for integer fields' do
    @table.filter(:year)

    @table.filters.first.is_a?(Tableficate::Filter::Input).should be true
    @table.filters.first.attrs[:type].should == 'number'
  end

  it 'should default the type to "number" for float fields' do
    @table.filter(:meaningless_float)

    @table.filters.first.is_a?(Tableficate::Filter::Input).should be true
    @table.filters.first.attrs[:type].should == 'number'
  end

  it 'should default the type to "number" for decimal fields' do
    @table.filter(:meaningless_decimal)

    @table.filters.first.is_a?(Tableficate::Filter::Input).should be true
    @table.filters.first.attrs[:type].should == 'number'
  end

  it 'should default the type to "date" for date fields' do
    @table.filter(:birthdate)

    @table.filters.first.is_a?(Tableficate::Filter::Input).should be true
    @table.filters.first.attrs[:type].should == 'date'
  end

  it 'should default the type to "time" for time fields' do
    @table.filter(:meaningless_time)

    @table.filters.first.is_a?(Tableficate::Filter::Input).should be true
    @table.filters.first.attrs[:type].should == 'time'
  end

  it 'should default the type to "datetime" for datetime fields' do
    @table.filter(:created_at)

    @table.filters.first.is_a?(Tableficate::Filter::Input).should be true
    @table.filters.first.attrs[:type].should == 'datetime'
  end

  it 'should default the type to "datetime" for timestamp fields' do
    @table.filter(:updated_at)

    @table.filters.first.is_a?(Tableficate::Filter::Input).should be true
    @table.filters.first.attrs[:type].should == 'datetime'
  end

  it 'should default the type based on the actual field, not the label' do
    template = mock('Template')
    template.stub!(:lookup_context).and_return(ActionView::LookupContext.new([]))
    template.lookup_context.stub!(:exists?).and_return(true)
    table = Tableficate::Table.new(template, NobelPrizeWinner.joins(:nobel_prizes).limit(1), {}, {field_map: {foo: 'year'}})

    table.filter(:foo)

    table.filters.first.is_a?(Tableficate::Filter::Input).should be true
    table.filters.first.attrs[:type].should == 'number'
  end

  it 'should add a InputRange filter' do
    @table.filter_range(:first_name, label: 'First')
    @table.filter_range(:last_name, label: 'Last')

    @table.filters.first.name.should == :first_name
    @table.filters.first.is_a?(Tableficate::Filter::InputRange).should be true
    @table.filters.last.name.should == :last_name
  end

  it 'should raise an error if InputRange is passed an unknown type' do
    lambda {@table.filter_range(:first_name, as: :foo)}.should raise_error(Tableficate::Filter::UnknownInputType)
  end

  it 'should add the InputRange for known types and pass through the type based on :as' do
    @table.filter_range(:first_name, as: :search)

    @table.filters.first.is_a?(Tableficate::Filter::InputRange).should be true
    @table.filters.first.attrs[:type].should == 'search'
  end

  it 'should add a Select filter' do
    @table.filter(:first_name, collection: {}, label: 'First')
    @table.filter(:last_name, collection: {}, label: 'Last')

    @table.filters.first.name.should == :first_name
    @table.filters.first.is_a?(Tableficate::Filter::Select).should be true
    @table.filters.last.name.should == :last_name
  end
end
