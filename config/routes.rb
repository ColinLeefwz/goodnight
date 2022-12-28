Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    namespace :v1 do
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
  end
end
