require 'spec_helper'

describe Tableficate::Utils do
  before(:each) do
    @template = mock('Template')
    @template.stub!(:lookup_context).and_return(ActionView::LookupContext.new([]))
  end

  it 'should construct a path with no theme' do
    @template.lookup_context.stub(:exists?).and_return(true)

    Tableficate::Utils::template_path(@template, 'table').should == 'tableficate/table'
  end

  it 'should construct a path with a theme' do
    @template.lookup_context.stub(:exists?).and_return(true)

    Tableficate::Utils::template_path(@template, 'table', 'futuristic').should == 'tableficate/futuristic/table'
  end

  it 'should fallback to a path with no theme if the theme does not have the requested partial' do
    @template.lookup_context.should_receive(:exists?) do |*args|
      (args.first == 'tableficate/table')
    end

    Tableficate::Utils::template_path(@template, 'table', 'futuristic').should == 'tableficate/table'
  end
end
