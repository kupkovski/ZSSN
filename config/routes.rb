Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users do
        member do
          put :update_location
          patch :update_location
        end
      end
    end
  end
end
