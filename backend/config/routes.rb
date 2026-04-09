Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Web Authentication
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  # API Authentication routes (Manual mapping to preserve existing API endpoints)
  namespace :api do
    namespace :v1 do
      devise_scope :user do
        post 'auth/login', to: 'sessions#create'
        delete 'auth/logout', to: 'sessions#destroy'
        post 'auth/signup', to: 'registrations#create'
      end
    end
  end


  # Hotwire Native 설정 엔드포인트
  get 'native/config', to: 'native#config'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  namespace :api do
    namespace :v1 do
      resources :status, only: [:index]
      resources :races, only: [:index, :show] do
        member do
          get :results
        end
      end
      resources :registrations, only: [:create, :index], controller: 'race_registrations'
      resource :profile, only: [:show, :update]

      namespace :admin do
        get 'dashboard', to: 'dashboard#index'
        resources :records, only: [] do
          collection do
            post :upload
          end
        end
      end

      # 커뮤니티 API
      resources :communities, only: [:index, :show], controller: "communities"

      # 대회 캘린더 API (통합 피드)
      resources :race_calendar, only: [:index, :show], controller: "race_calendar"
    end
  end

  resources :registrations, only: [:index, :show, :new, :create]
  resources :crews, only: [:index, :new, :create, :show]

  # 커뮤니티 디렉토리 (공개)
  resources :communities, only: [:index, :show], controller: "communities"

  # 대회 캘린더 (외부 대회 포함)
  get "race-calendar", to: "race_calendar#index", as: :race_calendar
  get "race-calendar/:id", to: "race_calendar#show", as: :race_calendar_show

  resources :races, only: [:index, :show] do
    resources :products, only: [:index]
  end
  resources :products, only: [:show]
  resource :cart, only: [:show] do
    post :add_item
    patch :update_quantity
    delete :remove_item
    delete :clear
  end
  resources :orders, only: [:index, :show, :new, :create]
  resources :rankings, only: [:index]
  resources :records, only: [:index, :show]
  resource :profile, only: [:show, :edit, :update]
  resource :onboarding, only: [:show, :update] do
    post :skip, on: :collection
  end

  # 커뮤니티 리더 대시보드
  namespace :dashboard do
    resource :community, only: [:show, :edit, :update], controller: "community" do
      post :submit_for_review
      delete :remove_photo
    end
  end

  namespace :admin do
    root to: "dashboard#index"
    resources :dashboard, only: [:index]
    resources :races
    resources :poster_analyses, only: [:create]
    resources :settlements, only: [:index] do
      member do
        post :approve
        post :reject
        post :mark_paid
      end
    end

    # 커뮤니티 관리 (어드민)
    resources :communities, controller: "communities" do
      member do
        patch :approve
        patch :suspend
        patch :feature
      end
    end

    # 외부 대회 관리
    resources :external_races, only: [:index, :edit, :update, :destroy]

    # 크롤링 소스 관리
    resources :crawl_sources do
      member do
        post :trigger_crawl
      end
    end
  end

  namespace :organizer do
    root to: "dashboard#index"
    resources :dashboard, only: [:index]
    resources :settlements, only: [:index, :show] do
      member do
        post :request_payout
      end
    end
    resources :races, only: [:index, :show] do
      member do
        get :payments          # 결제 현황
      end

      resources :bib_numbers, only: [:index, :update] do
        post :bulk_reassign, on: :collection
      end

      resources :participants, only: [:index, :show]

      resources :souvenirs, only: [:index] do
        member do
          post :mark_received
        end
      end

      resources :records, only: [:index] do
        collection do
          get :upload_form
          post :bulk_upload
          get :upload_result
          get :download_sample
        end
      end

      resources :record_statistics, only: [:index]

      resources :products do
        member do
          delete :delete_image
        end
      end
    end
  end

  # 개인정보처리방침 및 이용약관
  get "privacy", to: "pages#privacy"
  get "terms", to: "pages#terms"

  root "home#index"

  # Vibers 통합 어드민 (기존 api 네임스페이스 밖에 독립적으로 추가)
  namespace :api do
    get  "vibers_admin",           to: "vibers_admin#index"
    get  "vibers_admin/resource",  to: "vibers_admin#resource"
  end
end
