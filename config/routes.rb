Metall2::Application.routes.draw do

  get "/content" => "content#service"
  post "/content" => "content#service"

  get "/tokens" => "tokens#service"
  post "/tokens" => "tokens#service"

  get "/keywords" => "keywords#service"
  post "/keywords" => "keywords#service"

  get "/detection" => "detection#service"
  post "/detection" => "detection#service"

  root :to => 'welcome#index'
end
