Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :users, only: [] do
    get :followers
    get :followings
    put :follow
    put :unfollow
    get :is_following
    post :clocked_in
    get :sleep_rank
  end
end
