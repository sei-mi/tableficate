require 'tableficate/engine'
require 'tableficate/utils'
require 'tableficate/column'
require 'tableficate/action_column'
require 'tableficate/filters/filter'
require 'tableficate/filters/input_filters'
require 'tableficate/filters/select_filter'
require 'tableficate/attributes'
require 'tableficate/table'
require 'tableficate/helper'
require 'tableficate/base'
require 'tableficate/active_record_extension'
require 'tableficate/version'

ActionView::Base.send(:include, Tableficate::Helper)
ActiveRecord::Base.send(:include, Tableficate::ActiveRecordExtension)
