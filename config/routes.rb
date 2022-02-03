Rails.application.routes.draw do
  post 'search/query' => 'search#index'
  get 'search/:query/keyword' => 'search#query', :as => 'search_keyword'
  root "movies#index"
  
  resources :movies do
    resources :reviews
  end

  get  'auth/:provider/callback' => 'sessions#create',:as => 'login'
  post 'logout' => 'sessions#destroy'
  get  'auth/failure' => 'sessions#failure'
end
