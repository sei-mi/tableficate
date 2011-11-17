require 'spec_helper'

describe Tableficate::Filter::TextField do
  before(:all) do
    @table = Tableficate::Table.new(nil, NobelPrizeWinner.joins(:nobel_prizes).limit(1), {}, {})
    @table.column(:first_name)
  end

  it 'should find the correct template type and fallback if it is not available' do
    #Tableficate::Filter::TextField.new(@table, :first_name).template.should == 'filters/input_field'

    #file = File.open('app/views/tableficate/filters/_text_field.html.erb', 'w')
    #Tableficate::Filter::TextField.new(@table, :first_name).template.should == 'filters/text_field'
    #File.delete(file.path)
  end
end
