require 'spec_helper'

describe Tableficate::Filter::TextField do
  before(:each) do
    template = mock('Template')
    template.stub!(:lookup_context).and_return(ActionView::LookupContext.new([]))
    template.lookup_context.stub!(:exists?).and_return(false)
    @table = Tableficate::Table.new(template, NobelPrizeWinner.joins(:nobel_prizes).limit(1), {}, {})
    @table.column(:first_name)
  end

  it 'should find the correct template type and fallback if it is not available' do
    lambda {Tableficate::Filter::TextField.new(@table, :first_name).template}.should raise_error(Tableficate::Filter::MissingTemplate)

    @table.template.lookup_context.should_receive(:exists?).with('tableficate/filters/input_field', [], true).and_return(true)
    Tableficate::Filter::TextField.new(@table, :first_name).template.should == 'filters/input_field'

    @table.template.lookup_context.should_receive(:exists?).with('tableficate/filters/text_field', [], true).and_return(true)
    Tableficate::Filter::TextField.new(@table, :first_name).template.should == 'filters/text_field'
  end
end
