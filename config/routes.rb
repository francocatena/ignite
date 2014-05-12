Rails.application.routes.draw do
  resources :images, path: 'i'

  resources :lessons, path: 'l', only: [] do
    resources :slides, path: 's'
    resources :feedbacks, path: 'f'
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
