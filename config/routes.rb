Metall2::Application.routes.draw do

  get "/content" => "content#service"
  post "/content" => "content#service"

  get "/tokens" => "tokens#service"
  post "/tokens" => "tokens#service"

  get "/keywords" => "keywords#service"
  post "/keywords" => "keywords#service"

  post "/batch/keywords" => "keywords#batch_service"
  get "/batch/keywords" => "keywords#batch_result", as: "batch_keywords_result"

  get "/detection" => "detection#service"
  post "/detection" => "detection#service"

  root :to => 'welcome#index'
end
