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

    class NoScope < Tableficate::Base; end
    lambda {NoScope.tableficate({})}.should raise_error(Tableficate::MissingScope)
  end

  it 'should allow for a default order' do
    class DefaultOrder < Tableficate::Base
      scope(:nobel_prize_winner)

      default_sort(:first_name)
    end
    npw = DefaultOrder.tableficate({})
    npw.order_values.should == ["#{npw.table_name}.first_name ASC"]
    npw.reverse_order_value.should == nil

    class DefaultOrderDesc < Tableficate::Base
      scope(:nobel_prize_winner)

      default_sort(:first_name, 'desc')
    end
    npw = DefaultOrderDesc.tableficate({})
    npw.order_values.should == ["#{npw.table_name}.first_name ASC"]
    npw.reverse_order_value.should be true

    class DefaultOrderWithOverride < Tableficate::Base
      scope(:nobel_prize_winner)

      default_sort(:full_name)

      column(:full_name, sort: 'first_name ASC, last_name ASC')
    end
    npw = DefaultOrderWithOverride.tableficate({})
    npw.order_values.should == ["first_name ASC, last_name ASC"]
    npw.reverse_order_value.should == nil

    class DefaultOrderWithOverrideDesc < Tableficate::Base
      scope(:nobel_prize_winner)

      default_sort(:full_name, 'desc')

      column(:full_name, sort: 'first_name ASC, last_name ASC')
    end
    npw = DefaultOrderWithOverrideDesc.tableficate({})
    npw.order_values.should == ["first_name ASC, last_name ASC"]
    npw.reverse_order_value.should be true
  end

  it 'should filter using match: "contains"' do
    class FilterByContainsInput < Tableficate::Base
      scope(:nobel_prize_winner)

      filter(:first_name, match: 'contains')
    end
    npw = FilterByContainsInput.tableficate({filter: {first_name: 'Al'}})
    npw.size.should == 1
    npw.first.first_name.should == 'Albert'
  end

  it 'should filter multiple inputs using match: "contains"' do
    class FilterByContainsInput < Tableficate::Base
      scope(:nobel_prize_winner)

      filter(:first_name, match: 'contains')
    end
    npw = FilterByContainsInput.tableficate({filter: {first_name: ['Al', 'Mar']}})
    npw.size.should == 2
    npw.first.first_name.should == 'Albert'
    npw.last.first_name.should == 'Marie'
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
    npw = BlockFilter.tableficate({filter: {full_name: 'Bohr'}})
    npw.first.first_name.should == 'Niels'
  end
end
