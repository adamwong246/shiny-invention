Rails.application.routes.draw do
  resources :uploaded_files
  resources :products
  resources :mass_data_points
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  get '/app', to: 'products#app'
end
