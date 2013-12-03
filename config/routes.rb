Qjitsu::Application.routes.draw do


  resources :dashboard
  match "dashboard" => "dashboard#index", :as => 'user_root'

  
  resources :incorrect_answers

  resources :exam_questions do
    resources :comments
    resources :score_boards, :only => [:create, :update]
    collection do
      get  :autocomplete_tag_name
      post :ratings
      get  :sparring_mode
      get  :exam_mode
      get  :overview
      get  :get_comments
      get  :get_tags
    end
    member do
      post :add
      post :remove
      post :up
      get  :get_comments
      get  :get_tags
    end
  end


  # This line mounts Forem's routes at /forums by default.
  # This means, any requests to the /forums URL of your application will go to Forem::ForumsController#index.
  # If you would like to change where this extension is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Forem relies on it being the default of "forem"
  mount Forem::Engine, :at => '/forums'
  resources :medical_cases do
    resources :comments
    resources :score_boards, :only => [:create, :update]
    get :tags


    collection do
      get :autocomplete_tag_name
      get :autocomplete_author_name
      post :ratings
      post :result
      get  :get_comments
      get  :get_tags
    end
    member do
      post :ratings
      post :add
      post :remove
      post :approved
      post :pending
      post :draft
      post :inactive
      get  :get_comments
      get  :get_tags
    end
  end

  get 'tags/:tag', to: 'medical_cases#index', as: :tag

  resources :ratings
  resources :favorites



  devise_for :users, controllers: { sessions: 'users/sessions' }
  devise_for :users, :path_names => { :sign_up => "register" }

  devise_scope :user do
    root to: "devise/sessions#new"
  end

  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/')


  resources :medical_organizations

  resources :medical_organizations, :except => [:destroy] do
    member do
      get :toggle_status
    end
  end

  namespace :admin do
    resources :users, :except=>[:new,:show] do
      get :toggle_status
      collection do
        get :invitations
        get :user_cases
        post :sessionclose
        get :remove_pending_invitaion
      end
    end
    resources :reports do
      collection do
        get :user_submitted_cases
        get :user_test
        get :user_aggregate
        get :questions
        get :org_assignments
      end
      member do
        get :questions
      end
    end
    resources :objectives, :except=>:show do
      member do

        get :toggle_status
      end
    end
    resources :races do
      member do
        get :toggle_status
      end
    end
    resources :medical_organizations do
      member do
        get :toggle_status
      end
    end
  end

  get "/myprofile/user_cases"
  get "/myprofile/user_history"
  get "/myprofile/exam_questions"


  post "/sent_invites" => "admin/users#send_invite", :as => 'invites'

  post "/exam_questions/up" => "exam_questions#up"
  get "/resend_invites" => "admin/users#resend_invite", :as => 'resend_invites'

  get "/myprofile" => "myprofile#edit", :as => 'profile'
  put "/profile" => "myprofile#update", :as => 'profile'

  get "about/index"
  match "/about" => "about#index"
  match "/myprofile" => "myprofile#edit"
  match '*a', :to => 'myprofile#routing'
end
