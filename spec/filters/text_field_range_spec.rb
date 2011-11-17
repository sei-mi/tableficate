require 'spec_helper'

describe Tableficate::Filter::TextFieldRange do
  before(:each) do
    template = mock('Template')
    template.stub!(:lookup_context).and_return(ActionView::LookupContext.new([]))
    template.lookup_context.stub!(:exists?).and_return(false)
    @table = Tableficate::Table.new(template, NobelPrizeWinner.limit(1), {}, {current_sort: {column: :first_name, dir: 'asc'}})
    @table.column(:first_name)
  end

  it 'should find the correct template type and fallback if it is not available' do
    lambda {Tableficate::Filter::TextFieldRange.new(@table, :first_name).template}.should raise_error(Tableficate::Filter::MissingTemplate)

    @table.template.lookup_context.should_receive(:exists?).with('tableficate/filters/input_field_range', [], true).and_return(true)
    Tableficate::Filter::TextFieldRange.new(@table, :first_name).template.should == 'filters/input_field_range'

    @table.template.lookup_context.should_receive(:exists?).with('tableficate/filters/text_field_range', [], true).and_return(true)
    Tableficate::Filter::TextFieldRange.new(@table, :first_name).template.should == 'filters/text_field_range'
  end
end
