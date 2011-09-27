require 'rails/all'
require 'tablificate/utils'

describe Tablificate::Utils do
  it 'should construct a path with no theme' do
    Tablificate::Utils::template_path('template.rb').should == 'tablificate/template.rb'
  end

  it 'should construct a path with a theme' do
    Tablificate::Utils::template_path('template.rb', 'futuristic').should == 'tablificate/futuristic/template.rb'
  end
end
