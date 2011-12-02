# Tableficate
A DSL for easy table creation with sorting and filtering. It tries to do to tables what simple_form and formtastic have done for forms. Below you'll find basic documentation with more compelete docs forthcoming.

## Installation

    $ gem install tableficate

If you're using Bundler, add this to your Gemfile:

    gem 'tableficate', '~0.2.0'

## Support

### Ruby
1.9+

### Rails
3.1+

### Templating
Any templating engine can be used. The default theme uses ERB.

### Database Framework
ActiveRecord

### Pagination
Any pagination can be used. The default theme has built-in support for Kaminari and will_paginate.

## Basic Usage
Let's say that we want to create a table that lists active accounts in the system with their time of creation and the name on the account.

Our controller:

    @accounts = Accounts.active.tableficate(params[:accounts]).page(params.try(:[], :accounts_page) || 1)

Here we're getting active accounts, calling tableficate and then paginating with Kaminari. Tableficate works on Arel objects and passes out an Arel so you can add things like pagination. We pass in the params for the table we'll create in the view. By default the params are stored under the primary table name of the query.

Our View:

    <%= table_for @accounts, show_sorts: true do |t|
      t.column :id, header: 'Account Number'
      t.column :created_at do |account|
        account.created_at.strftime('%m/%d/%Y')
      end
      t.column :first_name
      t.column :last_name
      t.actions do |account|
        link_to('View', account_path(account))
      end

      t.filter :first_name
      t.filter :last_name
    %>

This creates a sortable table with two filters, 4 data columns and an action column. Column headers are automatically generated but can be overridden as seen on the "id" column. The column output can also be overridden by passing a block to the call. This setup provides easy table creation but only covers basic functionality. Some of the more advanced functionality requires you to wrap your scope in a special table model.

Having created the basic table we now want to default the sorting to show newest accounts first and we want the first and last name to be merged into one name column. First we'll need to create a table model.

In "app/tables/" we'll create a new table model. This can be done using a generator.

    $ rails generate tableficate:table AccountReport

Our table model:

    class AccountReport < Tableficate::Base
      scope do
        Accounts.active
      end

      default_sort(:created_at, 'DESC')

      column(:full_name, sort: 'first_name ASC, last_name ASC')

      filter(:full_name) do |value, scope|
        first_name, last_name = value.split(/\s+/)

        if last_name.nil?
          scope.where(['first_name LIKE ? OR last_name LIKE ?', first_name, first_name])
        else
          scope.where(['first_name LIKE ? AND last_name LIKE ?', first_name, last_name])
        end 
      end
    end

We've defined a scope that we're wrapping. Then we provide a default sorting and explain how to sort and filter a new column called ":full_name".

Our new controller:

    @accounts = AccountReport.tableficate(params[:accounts]).page(params.try(:[], :accounts_page) || 1)

The only change here is that "Accounts.active" has changed to "AccountReport".

Our new view:

    <%= table_for @accounts, show_sorts: true do |t|
      t.column :id, header: 'Account Number'
      t.column :created_at do |account|
        account.created_at.strftime('%m/%d/%Y')
      end
      t.column :full_name
      t.actions do |account|
        link_to('View', account_path(account))
      end

      t.filter :full_name
    %>

In the view we've merged the first and last name into a new full name column. Now we have default sorting, sortable columns and a full name filter.

## Themes

New themes can be created using the theme generator.

    $ rails generate tableficate:theme NAME

The theme can then be applied to a table by passing "theme: 'NAME'" to the "table_for" call.

    <%= table_for @accounts, theme: 'foo' do |t|
      ...
    %>

## Changes From 0.1

1. The filter functions used in the "table_for" call have been completely changed. They will need to be rewritten in all of your calls.
2. New filter partials have been added to accomodate the new filter types that are available. If you have custom themes they will need to be updated. This can be done by first moving "_column_header.html.erb" to "_header.html.erb", "filters/_input_field.html.erb" to "filters/_input.html.erb" and "filters/_input_field_range.html.erb" to "filters/_input_range.html.erb". Then rerun 'rails generate tableficate:theme <name>'. This will not overwrite files you have altered for your new theme.
