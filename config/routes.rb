Rails.application.routes.draw do
  root "movies#index"
  resources :movies do
    resources :reviews
  end

  get  'auth/:provider/callback' => 'sessions#create',:as => 'login'
  post 'logout' => 'sessions#destroy'
  get  'auth/failure' => 'sessions#failure'
end
