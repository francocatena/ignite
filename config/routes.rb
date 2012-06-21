Ignite::Application.routes.draw do
  resources :feedbacks, path: 'f'

  resources :images, path: 'i'

  resources :lessons, path: 'l', only: [] do
    resources :slides, path: 's'
  end
  
  resources :courses, path: 'c' do
    resources :lessons, path: 'l'
  end
  
  match(
    'slides/execute_ruby' => 'slides#execute_ruby',
    as: 'execute_ruby', via: :post
  )
  
  root to: 'courses#index'
end
