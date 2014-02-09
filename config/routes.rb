MusicData::Application.routes.draw do
  unless Rails.env.test?
    require 'sidekiq/web'

    mount Sidekiq::Web => '/sidekiq'
  end

  resources :artists

  root 'welcome#index'
end
