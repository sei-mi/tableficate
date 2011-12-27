require 'spec_helper'

describe Tableficate::Empty do
  before(:each) do
    @table = Tableficate::Table.new(nil, NobelPrizeWinner.limit(1), {}, {})
  end

  it 'should add a `colspan` attribute' do
    @table.column(:first_name)
    @table.column(:last_name)
    empty = Tableficate::Empty.new(@table, 'Foo')

    empty.attrs[:colspan].should == 2
  end

  it 'should accept plain text in the arguments' do
    empty = Tableficate::Empty.new(@table, 'Foo', {class: 'title'})

    empty.attrs[:class].should == 'title'
    empty.value.should == 'Foo'
  end

  it 'should take a block in place of the plain text argument' do
    empty = Tableficate::Empty.new(@table, {class: 'title'}) do
      'Foo'
    end

    empty.attrs[:class].should == 'title'
    empty.value.should == 'Foo'
  end
  it 'should not escape html in block outputs' do
    empty = Tableficate::Empty.new(@table) do
      '<b>Foo</b>'
    end

    ERB::Util::html_escape(empty.value).should == '<b>Foo</b>'
  end
  it 'should allow ERB tags in block outputs' do
    empty = Tableficate::Empty.new(@table) do
      ERB.new("<%= 'Foo'.upcase %>").result(binding)
    end

    empty.value.should == 'FOO'
  end
end
