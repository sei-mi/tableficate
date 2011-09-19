require 'tablificate/engine'
require 'tablificate/column'
require 'tablificate/filter'
require 'tablificate/input_filter'
require 'tablificate/table'
require 'tablificate/helper'
require 'tablificate/base'
require 'tablificate/active_record_extension'
require 'tablificate/version'

ActionView::Base.send(:include, Tablificate::Helper)
ActiveRecord::Base.send(:include, Tablificate::ActiveRecordExtension)
