require 'spec_helper'

describe Tableficate::Caption do
  it 'should accept plain text in the arguments' do
    caption = Tableficate::Caption.new('Foo', {class: 'title'})

    caption.attrs[:class].should == 'title'
    caption.value.should == 'Foo'
  end

  it 'should take a block in place of the plain text argument' do
    caption = Tableficate::Caption.new({class: 'title'}) do
      'Foo'
    end

    caption.attrs[:class].should == 'title'
    caption.value.should == 'Foo'
  end
  it 'should not escape html in block outputs' do
    caption = Tableficate::Caption.new do
      '<b>Foo</b>'
    end

    ERB::Util::html_escape(caption.value).should == '<b>Foo</b>'
  end
  it 'should allow ERB tags in block outputs' do
    caption = Tableficate::Caption.new do
      ERB.new("<%= 'Foo'.upcase %>").result(binding)
    end

    caption.value.should == 'FOO'
  end
end
