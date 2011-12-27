TestApp::Application.routes.draw do
  root controller: 'tests', action: 'index'

  match ':controller(/:action(/:id(.:format)))'
end
