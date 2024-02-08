Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users do
        member do
          put :update_location
          patch :update_location
          put :report_infected
          patch :report_infected

          resource :inventory do
            member do
              post :add_item
              delete :remove_item
              put :exchange_item
              patch :exchange_item
            end
          end
        end
      end
    end
  end
end
