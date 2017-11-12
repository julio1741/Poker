Rails.application.routes.draw do
  get 'deck/index'

  get 'deck' => 'deck#index'
  get 'new_hands/:token' => 'deck#new_hands', :as => :new_hands
end
