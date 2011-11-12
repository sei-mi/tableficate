require 'spec_helper'
require 'genspec'

describe 'tableficate:theme' do
  with_args :foo do
    it 'should generate app/views/tableficate/foo/ with all files' do
      subject.should generate('app/views/tableficate/foo')
      subject.should generate('app/views/tableficate/foo/_table.html.erb')
    end
  end
end
