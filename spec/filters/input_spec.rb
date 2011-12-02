require 'spec_helper'

describe Tableficate::Filter::Input do
  before(:each) do
    template = mock('Template')
    template.stub!(:lookup_context).and_return(ActionView::LookupContext.new([]))
    @table = Tableficate::Table.new(template, NobelPrizeWinner.joins(:nobel_prizes).limit(1), {}, {})
    @table.column(:first_name)
  end

  it 'should look for a partial based on the input type and use it if found' do
    @table.template.lookup_context.stub(:exists?).and_return(true)

    Tableficate::Filter::Input.new(@table, :first_name, type: 'search').template.should == 'filters/input_search'
  end

  it 'should look for a partial based on the input type and use the default if it is not found' do
    @table.template.lookup_context.should_receive(:exists?) do |*args|
      (args.first == 'tableficate/filters/input')
    end

    Tableficate::Filter::Input.new(@table, :first_name, type: 'search').template.should == 'filters/input'
  end
end
