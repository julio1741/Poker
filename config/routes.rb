Rails.application.routes.draw do
  get 'deck/index'

  get 'deck' => 'deck#index'

end
