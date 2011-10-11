require 'spec_helper'

describe Tableficate::Base do
  it 'should set the scope' do
    class SymbolScope < Tableficate::Base
      scope(:nobel_prize_winner)
    end
    SymbolScope.send(:instance_variable_get, '@scope').should == NobelPrizeWinner

    class BlockScope < Tableficate::Base
      scope do
        NobelPrizeWinner.joins(:nobel_prizes)
      end
    end
    BlockScope.send(:instance_variable_get, '@scope').should == NobelPrizeWinner.joins(:nobel_prizes)
  end

  it 'should allow for a default order' do
    class DefaultOrder < Tableficate::Base
      scope(:nobel_prize_winner)

      default_sort(:first_name)
    end
    npw = DefaultOrder.find_by_params({})
    npw.order_values.should == ["#{npw.table_name}.first_name ASC"]
    npw.reverse_order_value.should == nil

    class DefaultOrderDesc < Tableficate::Base
      scope(:nobel_prize_winner)

      default_sort(:first_name, 'desc')
    end
    npw = DefaultOrderDesc.find_by_params({})
    npw.order_values.should == ["#{npw.table_name}.first_name ASC"]
    npw.reverse_order_value.should be true

    class DefaultOrderWithOverride < Tableficate::Base
      scope(:nobel_prize_winner)

      default_sort(:full_name)

      column(:full_name, sort: 'first_name ASC, last_name ASC')
    end
    npw = DefaultOrderWithOverride.find_by_params({})
    npw.order_values.should == ["first_name ASC, last_name ASC"]
    npw.reverse_order_value.should == nil

    class DefaultOrderWithOverrideDesc < Tableficate::Base
      scope(:nobel_prize_winner)

      default_sort(:full_name, 'desc')

      column(:full_name, sort: 'first_name ASC, last_name ASC')
    end
    npw = DefaultOrderWithOverrideDesc.find_by_params({})
    npw.order_values.should == ["first_name ASC, last_name ASC"]
    npw.reverse_order_value.should be true
  end

  it 'should filter based on single input passed in' do
    class FilterByExactInput < Tableficate::Base
      scope(:nobel_prize_winner)
    end
    npw = FilterByExactInput.find_by_params({filter: {first_name: 'Albert'}})
    npw.size.should == 1
    npw.first.first_name.should == 'Albert'
    npw = FilterByExactInput.find_by_params({filter: {first_name: 'Al'}})
    npw.size.should == 0

    class FilterByContainsInput < Tableficate::Base
      scope(:nobel_prize_winner)

      filter(:first_name, match: 'contains')
    end
    npw = FilterByContainsInput.find_by_params({filter: {first_name: 'Al'}})
    npw.size.should == 1
    npw.first.first_name.should == 'Albert'
  end

  it 'should filter based on multiple inputs passed in' do
    class FilterByExactInput < Tableficate::Base
      scope(:nobel_prize_winner)
    end
    npw = FilterByExactInput.find_by_params({filter: {first_name: ['Albert', 'Marie']}})
    npw.size.should == 2
    npw.first.first_name.should == 'Albert'
    npw.last.first_name.should == 'Marie'
    npw = FilterByExactInput.find_by_params({filter: {first_name: ['Al', 'Mar']}})
    npw.size.should == 0

    class FilterByContainsInput < Tableficate::Base
      scope(:nobel_prize_winner)

      filter(:first_name, match: 'contains')
    end
    npw = FilterByContainsInput.find_by_params({filter: {first_name: ['Al', 'Mar']}})
    npw.size.should == 2
    npw.first.first_name.should == 'Albert'
    npw.last.first_name.should == 'Marie'
  end

   it 'should attach the table name to the fields from the primary table to avoid ambiguity' do
    class PrimaryTable < Tableficate::Base
      scope do
        NobelPrizeWinner.joins(:nobel_prizes)
      end

      default_sort(:first_name)
    end
    npw = PrimaryTable.find_by_params({})
    npw.order_values.should == ["#{npw.table_name}.first_name ASC"]

    # secondary table fields are left vague for maximum flexibility
    class SecondaryTable < Tableficate::Base
      scope do
        NobelPrizeWinner.joins(:nobel_prizes)
      end

      default_sort(:year)
    end
    npw = SecondaryTable.find_by_params({})
    npw.order_values.should == ["year ASC"]
   end

   it 'should allow ranged input filters' do
     class NobelPrizeYear < Tableficate::Base
       scope(:nobel_prize)
     end
     npy = NobelPrizeYear.find_by_params({filter: {year: {start: 1900, stop: 1930}}})
     npy.size.should == 4
   end

   it 'should allow custom block filters' do
     class BlockFilter < Tableficate::Base
       scope(:nobel_prize_winner)

       filter(:full_name) do |scope, value|
         first_name, last_name = value.split(/\s+/)

         if last_name.nil?
           scope.where(['first_name LIKE ? OR last_name LIKE ?', first_name, first_name])
         else
           scope.where(['first_name LIKE ? AND last_name LIKE ?', first_name, last_name])
         end 
       end 
     end
     npw = BlockFilter.find_by_params({filter: {full_name: 'Bohr'}})
     npw.first.first_name.should == 'Niels'
   end
end
