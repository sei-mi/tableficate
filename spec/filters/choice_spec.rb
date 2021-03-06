require 'spec_helper'

describe Tableficate::Filter::Choice do
  it 'should mark a choice as selected if it has a :selected or :checked option' do
    choice = Tableficate::Filter::Choice.new('foo', 'bar', {selected: 'selected'})
    choice.selected?.should be true
    choice.attrs[:selected].should be nil

    choice = Tableficate::Filter::Choice.new('foo', 'bar')
    choice.selected?.should be false

    choice = Tableficate::Filter::Choice.new('foo', 'bar', {checked: 'checked'})
    choice.checked?.should be true
    choice.attrs[:checked].should be nil
  end
end
