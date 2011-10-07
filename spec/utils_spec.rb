require 'spec_helper'

describe Tableficate::Utils do
  it 'should construct a path with no theme' do
    Tableficate::Utils::template_path('template.rb').should == 'tableficate/template.rb'
  end

  it 'should construct a path with a theme' do
    Tableficate::Utils::template_path('template.rb', 'futuristic').should == 'tableficate/futuristic/template.rb'
  end
end
