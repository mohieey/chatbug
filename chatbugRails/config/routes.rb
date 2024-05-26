Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  scope :users do
    post :signup, to: 'users#sign_up'
    post :signin, to: 'users#sign_in'
  end

  scope :applications do
    get :'', to: 'applications#index'
    post :create, to: 'applications#create'

    scope '/:application_token/chats' do
      get :'', to: 'chats#index'

      scope '/:chat_number/messages' do
        get :'', to: 'messages#index'
      end
    end
  end


  # Defines the root path route ("/")
  # root "posts#index"
end
