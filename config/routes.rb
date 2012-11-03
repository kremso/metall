Metall2::Application.routes.draw do

  get "/content" => "content#service"
  post "/content" => "content#service"

  root :to => 'welcome#index'
end
