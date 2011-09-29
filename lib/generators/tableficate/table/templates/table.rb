class <%= class_name %> < Tableficate::Base
<% if scope -%>
  scope :<%= scope.tableize %>
<% end -%>
end
