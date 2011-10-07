require 'spec_helper'

describe Tableficate::Base do
  it 'should set the scope' do
    class SymbolScope < Tableficate::Base
      scope(:nobel_prize_winner)
    end
    SymbolScope.send(:instance_variable_get, '@scope').should == NobelPrizeWinner

    class BlockScope < Tableficate::Base
      scope do
        NobelPrizeWinner
      end
    end
    BlockScope.send(:instance_variable_get, '@scope').should == NobelPrizeWinner
  end
end
