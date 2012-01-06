require 'spec_helper'

describe 'Tableficate::ActiveRecordExtention' do
  it 'should add and retreive data from the scope' do
    scope = NobelPrizeWinner.tableficate_ext
    scope.tableficate_data = {}
    scope.tableficate_data[:name] = 'Aaron'
    scope.tableficate_data.should == {name: 'Aaron'}
  end

  it 'maintains functionality if converted to an array' do
    scope = NobelPrizeWinner.tableficate_ext.to_a
    scope.tableficate_data = {}
    scope.tableficate_data[:name] = 'Aaron'
    scope.tableficate_data.should == {name: 'Aaron'}

    class NobelPrizeWinnerWithDefaultSorting < Tableficate::Base
      scope :nobel_prize_winner

      default_sort(:first_name)
    end
    scope = NobelPrizeWinnerWithDefaultSorting.tableficate({}).all
    scope.tableficate_data[:current_sort].should == {column: :first_name, dir: 'asc'}

    scope = NobelPrizeWinnerWithDefaultSorting.tableficate({}).find(1,2)
    scope.tableficate_data[:current_sort].should == {column: :first_name, dir: 'asc'}
  end
end
