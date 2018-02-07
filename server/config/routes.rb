Rails.application.routes.draw do
  root 'main#index'
  get 'about', to: 'about#index'
  get 'instructions', to: 'instructions#index'

  post 'mix', to: 'result#mix'
end
