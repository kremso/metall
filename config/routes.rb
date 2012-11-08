Metall2::Application.routes.draw do

  get "/content" => "content#service"
  post "/content" => "content#service"

  get "/keywords" => "keywords#service"
  post "/keywords" => "keywords#service"

  root :to => 'welcome#index'
end
