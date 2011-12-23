require 'spec_helper'
require 'genspec'

describe 'tableficate:theme' do
  with_args :foo do
    it 'should generate app/views/tableficate/foo/ with all files' do
      subject.should generate('app/views/tableficate/foo')
      subject.should generate('app/views/tableficate/foo/_table.html.erb')
    end
  end

  with_args :foo, 'table_for' do
    it 'should generate a single file in app/views/tableficate/foo/' do
      subject.should generate('app/views/tableficate/foo')
      subject.should generate('app/views/tableficate/foo/_table_for.html.erb')
    end
  end

  with_args :foo, 'filters/form' do
    it 'should generate a single file in app/views/tableficate/foo/filters' do
      subject.should generate('app/views/tableficate/foo/filters')
      subject.should generate('app/views/tableficate/foo/filters/_form.html.erb')
    end
  end
end
