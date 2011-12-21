require 'spec_helper'

describe Tableficate::Caption do
  it 'should accept plain text in the arguments' do
    caption = Tableficate::Caption.new('Foo', {class: 'title'})

    caption.attrs[:class].should == 'title'
    caption.value.should == 'Foo'
  end

  it 'should take a block with HTML in place of the plain text argument' do
    caption = Tableficate::Caption.new({class: 'title'}) do
      '<b>Foo</b>'
    end

    caption.attrs[:class].should == 'title'
    caption.value.should == '<b>Foo</b>'
  end
end
