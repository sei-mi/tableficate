class TestsController < ApplicationController
  def index
    @files = Dir[File.join(Rails.root, 'app', 'views', '**', '*.html.erb')].reject{|file| File.dirname(file) =~ /views\/(tableficate|layouts|tests)/}
  end
end
