Rails.application.routes.draw do
  root 'itineraries#new' # direct root to the new action of ItinerariesController
  resources :itineraries, only: [:create, :show] # routes for create and show actions
  resources :itineraries do
    resources :places, only: [:new, :create]
  end
end
