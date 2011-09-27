require 'tablificate/engine'
require 'tablificate/utils'
require 'tablificate/column'
require 'tablificate/action_column'
require 'tablificate/filters/filter'
require 'tablificate/filters/input_filters'
require 'tablificate/filters/select_filter'
require 'tablificate/attributes'
require 'tablificate/table'
require 'tablificate/helper'
require 'tablificate/base'
require 'tablificate/active_record_extension'
require 'tablificate/version'

ActionView::Base.send(:include, Tablificate::Helper)
ActiveRecord::Base.send(:include, Tablificate::ActiveRecordExtension)
