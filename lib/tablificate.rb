require 'tablificate/engine'
require 'tablificate/table'
require 'tablificate/helper'
require 'tablificate/version'

ActionView::Base.send(:include, Tablificate::Helper)
