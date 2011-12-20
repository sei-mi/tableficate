require 'spec_helper'

describe Tableficate::Filter::Collection do
  it 'allows for a collection to accept a range' do
    collection = Tableficate::Filter::Collection.new(1..3)

    1.upto(3) do |i|
      index = i - 1
      collection[index].name.should == i
      collection[index].value.should == i
      collection[index].selected?.should be false
    end
  end

  it 'allows for a collection to accept a hash' do
    h = {one: 1, two: 2, three: 3}

    collection = Tableficate::Filter::Collection.new(h)

    i = 0
    h.each do |key, value|
      collection[i].name.should == key
      collection[i].value.should == value
      collection[i].selected?.should be false
      i += 1
    end
  end

  it 'allows for a collection to accept an array' do
    a = [*1..3]

    collection = Tableficate::Filter::Collection.new(a)

    1.upto(3) do |i|
      index = i - 1
      collection[index].name.should == i
      collection[index].value.should == i
      collection[index].selected?.should be false
    end
  end

  it 'allows for a collection to accept a nested array' do
    a = [[:one, 1], [:two, 2], [:three, 3]]

    collection = Tableficate::Filter::Collection.new(a)

    0.upto(2) do |i|
      key, value = a[i]
      collection[i].name.should == key
      collection[i].value.should == value
      collection[i].selected?.should be false
    end
  end

  it 'should mark choices as selected based on the :selected option' do
    a = [*1..3]

    collection = Tableficate::Filter::Collection.new(a, selected: 2)

    1.upto(3) do |i|
      collection[i - 1].selected?.should be (i == 2)
    end

    collection = Tableficate::Filter::Collection.new(a, selected: [2, 3])

    1.upto(3) do |i|
      collection[i - 1].selected?.should be (i == 2 or i == 3)
    end
  end

  it 'should mark choices as disabled based on the :disabled option' do
    a = [*1..3]

    collection = Tableficate::Filter::Collection.new(a, disabled: 2)

    1.upto(3) do |i|
      if i == 2
        collection[i - 1].attrs[:disabled].should == 'disabled'
      else
        collection[i - 1].attrs.has_key?(:disabled).should be false
      end
    end

    collection = Tableficate::Filter::Collection.new(a, disabled: [2, 3])

    1.upto(3) do |i|
      if i == 2 or i == 3
        collection[i - 1].attrs[:disabled].should == 'disabled'
      else
        collection[i - 1].attrs.has_key?(:disabled).should be false
      end
    end
  end
end
