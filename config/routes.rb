Rails.application.routes.draw do
  devise_for :users
	root 'shifts#index'
	resources :shifts
	resources :roles
	post "shifts/reply" => "shifts#reply"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
