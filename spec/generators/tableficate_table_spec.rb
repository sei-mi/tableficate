require 'spec_helper'
require 'genspec'

describe 'tableficate:table' do
  with_args :foo do
    it 'should generate app/tables/foo.rb' do
      subject.should generate('app/tables/foo.rb') { |content|
        content.should =~ /class Foo < Tableficate\:\:Base/
      }
    end
  end

  with_args :foo, :bar do
    it 'should generate app/tables/foo.rb with a scope' do
      subject.should generate('app/tables/foo.rb') { |content|
        content.should =~ /scope \:bar/
      }
    end
  end

  with_args :foo, 'NobelPrizeWinner' do
    it 'should generate app/tables/foo.rb with a scope based on the model' do
      subject.should generate('app/tables/foo.rb') { |content|
        content.should =~ /scope \:nobel_prize_winner/
      }
    end
  end
end
