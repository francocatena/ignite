Ignite::Application.routes.draw do
  resources :images

  resources :lessons, only: [] do
    resources :slides
  end
  
  resources :courses do
    resources :lessons
  end
  
  match 'slides/execute_ruby' => 'slides#execute_ruby', as: :execute_ruby,
    via: :post
  
  root to: 'courses#index'
end
