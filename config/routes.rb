Rails.application.routes.draw do

  root :to => 'deck#index'
  get 'deck/index'

  get 'new_hands/:token' => 'deck#new_hands', :as => :new_hands
end
