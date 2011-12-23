class <%= class_name %> < Tableficate::Base
<% if scope -%>
  scope :<%= scope.underscore %>
<% end -%>
end
