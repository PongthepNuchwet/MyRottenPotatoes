Rails.application.routes.draw do
  post 'search/query' => 'search#index'
  get 'search/:query/keyword' => 'search#query', :as => 'search_keyword'
  root "movies#index"
  
  resources :movies do
    resources :reviews
  end

  get "movies/filters/for_kids" => 'movies#for_kids'
  post "movies/filters/recently_reviewed" => 'movies#recently_reviewed' ,:as => 'recently_review'
  get "filters" => 'movies#filters' ,:as => 'movies_filters'

  get  'auth/:provider/callback' => 'sessions#create',:as => 'login'
  post 'logout' => 'sessions#destroy'
  get  'auth/failure' => 'sessions#failure'
end
