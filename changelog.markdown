## 0.3.0
 * tables no longer take the :html option, all non-recognized options are passed through as HTML attributes
 * The `options` attribute on a variety of objects has been removed. It has been replaced with specialized functions such as `label_options` and `collection` with all unrecognized options placed into the `attrs` attribute.
 * adding `tableficate_table_tag` helper
 * adding `tableficate_filter_form_tag` helper
 * adding support for captions
 * missing theme partials will default to the standard partial
 * tableficate:theme generator now takes an optional `PARTIAL` arg to specify one file

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
