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
end
