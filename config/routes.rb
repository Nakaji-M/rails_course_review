Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    # Form routes
    get 'form/:year', to: 'forms#show'
    post 'form', to: 'forms#create'
    
    # Question routes
    post 'question', to: 'questions#create'
    
    # Answer routes
    get 'answer/:course_id', to: 'answers#show'
    post 'answer', to: 'answers#create'
    
    # Course routes
    get 'course/:year/:department_id', to: 'courses#index'
    post 'course', to: 'courses#create'
    delete 'course/:course_id', to: 'courses#destroy'
    
    # Department routes
    get 'department', to: 'departments#index'
    post 'department', to: 'departments#create'
  end
end
