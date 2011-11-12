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

  with_args :foo, :bars do
    it 'should generate app/tables/foo.rb' do
      subject.should generate('app/tables/foo.rb') { |content|
        content.should =~ /scope \:bars/
      }
    end
  end
end
