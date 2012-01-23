## 0.4.0
 * the match option on filters takes symbols
 * adding support for hidden filters

## 0.3.2
 * fix join table name finder in find_column_type

## 0.3.1
 * converting scope to an array through functions like `all` no longer breaks

## 0.3.0
 * tables no longer take the :html option, all non-recognized options are passed through as HTML attributes
 * The `options` attribute on a variety of objects has been removed. It has been replaced with specialized functions such as `label_options` and `collection` with all unrecognized options placed into the `attrs` attribute.
 * adding `tableficate_table_tag` helper
 * adding `tableficate_filter_form_tag` helper
 * adding support for captions
 * missing theme partials will default to the standard partial
 * tableficate:theme generator now takes an optional `PARTIAL` arg to specify one file
 * `actions` now takes options just like `column`
 * `column` now takes a `header_attrs` option to provide attributes for the `th`
 * `column` now takes a `cell_attrs` option to provide attributes for every `td` in the column, a proc can be passed in place of a string for attributes to customize on a per cell basis
 * `column` now places all unrecognized options into the `attrs` attribute which is used on a `col` tag
 * adding `empty` to display a message when a table has no data
 * input types are automatically figured out by label name and DB column type
 * `tableficate_radio_tags` and `tableficate_check_box_tags` use partials now rather than block formatting
 * dates and date ranges used against datetime and timestamp columns will automatically work as expected (i.e. 01/01/2011 will get everything between 00:00:00 and 23:59:59 for that day)

## 0.2.1
 * fix table generator to provide `scope` the proper argument and correct documentation

## 0.2.0
 * complete filter rewrite
 * replaced existing filter functions in table_for calls
 * added select based range filter
 * added radio button filter
 * added check box filter
 * `column` and `actions` calls in `table_for` now accept template blocks

## 0.1.3
* fixing html_safe break in 0.1.2

## 0.1.2
* only call html_safe when needed on column block calls

## 0.1.1
* corrected version file

## 0.1.0
 * initial release
