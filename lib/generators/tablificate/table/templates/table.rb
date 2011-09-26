class <%= class_name %> < Tablificate::Base
<% if scope -%>
  scope :<%= scope.tableize %>
<% end -%>
end
