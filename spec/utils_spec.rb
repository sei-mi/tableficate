require 'spec_helper'

describe Tableficate::Utils do
  describe 'template_path' do
    before(:each) do
      @template = mock('Template')
      @template.stub!(:lookup_context).and_return(ActionView::LookupContext.new([]))
    end

    it 'should construct a path with no theme' do
      @template.lookup_context.stub(:exists?).and_return(true)

      Tableficate::Utils::template_path(@template, 'table').should == 'tableficate/table'
    end

    it 'should construct a path with a theme' do
      @template.lookup_context.stub(:exists?).and_return(true)

      Tableficate::Utils::template_path(@template, 'table', 'futuristic').should == 'tableficate/futuristic/table'
    end

    it 'should fallback to a path with no theme if the theme does not have the requested partial' do
      @template.lookup_context.should_receive(:exists?) do |*args|
        (args.first == 'tableficate/table')
      end

      Tableficate::Utils::template_path(@template, 'table', 'futuristic').should == 'tableficate/table'
    end
  end

  describe 'find_column_type' do
    it 'should find the column type' do
      Tableficate::Utils::find_column_type(NobelPrizeWinner, :first_name).should == :string
    end

    it 'should find the column in a join' do
      Tableficate::Utils::find_column_type(NobelPrizeWinner.joins(:nobel_prizes), :year).should == :integer

      # pluralization of the join type should be accounted for
      Tableficate::Utils::find_column_type(NobelPrize.joins(:nobel_prize_winner), :birthdate).should == :date
    end

    it 'should find the column for manual joins' do
      Tableficate::Utils::find_column_type(NobelPrizeWinner.joins('JOIN nobel_prizes ON nobel_prizes.nobel_prize_winner_id = nobel_prize_winners.id'), :shared).should == :boolean

      Tableficate::Utils::find_column_type(NobelPrizeWinner.joins('JOIN nobel_prizes USING(id, id)'), :shared).should == :boolean
    end

    it 'should return `nil` for unknown columns' do
      Tableficate::Utils::find_column_type(NobelPrizeWinner, :foo).should == nil
    end
  end
end
