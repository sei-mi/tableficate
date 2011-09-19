require 'rails'
require 'tablificate/column'

describe Tablificate::Column do
  it 'should generate a header if none is provided' do
    column = Tablificate::Column.new(nil, nil, :alter_ego)

    column.header.should == 'Alter Ego'
  end
  it 'should show the header if provided' do
    column = Tablificate::Column.new(nil, nil, :superhero_union_id, header: 'SUID')

    column.header.should == 'SUID'
  end

  it 'should show the value from the database field if no alternative is provided' do
    row = mock('SuperHero')
    row.stub!(:alter_ego).and_return('Walter Kovacs')

    column = Tablificate::Column.new(nil, nil, :alter_ego)

    column.value(row).should == 'Walter Kovacs'
  end
  it 'should return the value provided from the block' do
    row = mock('SuperHero')
    row.stub!(:birthdate).and_return(Time.utc(2000, 9, 12, 13, 45, 37))

    column = Tablificate::Column.new(nil, nil, :born_at, format: Proc.new {|row| row.birthdate.strftime('%B %d, %Y at %I:%M:%S %P')})

    column.value(row).should == 'September 12, 2000 at 01:45:37 pm'
  end

  it 'should allow sorting to be turned on and off' do
    column = Tablificate::Column.new(nil, nil, :foo, sortable: false)
    column.sortable?.should be false

    column = Tablificate::Column.new(nil, nil, :foo, sortable: true)
    column.sortable?.should be true

    column = Tablificate::Column.new(nil, nil, :foo)
    column.sortable?.should be false
  end

  it 'should allow filtering to be turned on and off' do
    column = Tablificate::Column.new(nil, nil, :foo, filterable: false)
    column.filterable?.should be false

    column = Tablificate::Column.new(nil, nil, :foo, filterable: true)
    column.filterable?.should be true

    column = Tablificate::Column.new(nil, nil, :foo)
    column.filterable?.should be false
  end
end
