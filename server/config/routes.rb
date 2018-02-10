Rails.application.routes.draw do
  root 'main#index'
  get 'about', to: 'about#index'
  get 'instructions', to: 'instructions#index'

  post 'mix', to: 'result#mix'

  match '*path' => redirect('/'), via: [:get, :post, :put] unless Rails.env.development?
end
