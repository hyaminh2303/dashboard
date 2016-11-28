Rails.application.routes.draw do
  resources :banners

  resources :app_categories, only: [:index]

  get 'geos/index'
  get 'geos/get_city'

  get 'timezones/index'

  get 'client_booking_campaigns/list'

  get 'client_booking_campaigns/steps'

  get 'client_booking_campaigns/step1'

  get 'client_booking_campaigns/step1_locations'

  get 'client_booking_campaigns/step2'

  get 'client_booking_campaigns/step3'

  get 'client_booking_campaigns/calculate_impression_assessment', as: :calculate_impression_assessment

  root 'home#index'

  resources :client_booking_campaigns do
    member do
      post :update_status
      get :generate
    end

    collection do
      get :search_locations
    end
  end

  resources :countries, only: [:index]

  resources :categories do
    collection do
      get :list
    end
  end
  resources :roles
  resources :users
  resources :order_settings do
    collection do
      get :show
      post :update_all
    end
  end

  get 'vast_generator' => 'vast#index'
  post 'vast_generator' => 'vast#create'

  post 'stats' => 'home#stats'

  get 'executive_report(_:date)' => 'executive_reports#index', as: 'executive_report'

  get 'monthly_campaign_summary' => 'campaign_summaries#monthly'

  resources :currencies do
    collection do
      post :usd
      get :list
    end
  end

  get 'platforms/stats' => 'platforms#stats'
  resources :platforms

  resources :sub_total_settings do
    collection do
      get :list
    end
  end

  resources :agencies do
    member do
      post :enable
      post :disable
      post :show_finance
      post :hide_finance
      post :send_invitation
      post :reset_password
      post :become
    end

    collection do
      get :list, format: :json
    end
  end
  post :become_admin, to: 'agencies#become_admin'

  resources :location_lists do
    member do
      post 'publish'
      post 'expire'
    end
  end

  resources :locations do
    member do
      post 'publish'
      post 'expire'
    end
    collection do
      get 'import'
      post 'import'
    end
  end

  resources :orders do
    member do
      post :publish
      post :expire
      get :export_io
    end
  end

  resources :sale_managers do
    collection do
      get :list
    end
  end

  resources :campaigns do
    collection do
      get ':id/import_io', to: 'campaigns#import_io', as: 'import_signed_io'
      patch ':id/import_io', to: 'campaigns#upload_io', as: 'upload_signed_io'
    end
    resources :daily_trackings do
      collection do
        get 'views'
        get 'clicks'
        get 'budget_spent'
        get 'import', to: 'daily_trackings#import'
        post 'import', to: 'daily_trackings#import_post'
      end
    end
    resources :location_trackings do
      collection do
        get 'import'
        post 'import'
        get 'heat'
      end
    end
    resources :os_trackings do
      collection do
        get 'import'
        post 'import'
        get 'heat'
        get 'destroy_all', to:'os_trackings#destroy_all'
      end
    end
    resources :app_trackings do
      collection do
        get 'import'
        post 'import'
        get 'heat'
        get 'destroy_all', to:'app_trackings#destroy_all'
      end
    end

    resources :creative_trackings do
      collection do
        get 'import'
        post 'import'
        get 'heat'
        get 'destroy_all', to:'creative_trackings#destroy_all'
      end
    end

    resources :device_trackings do
      collection do
        get 'import'
        post 'import'
        get 'heat'
        get 'destroy_all', to:'device_trackings#destroy_all'
      end
    end

    resources :rich_media_trackings do
      collection do
        get 'import'
        post 'import'
        get 'heat'
      end
    end


    resources :campaign_ads_groups, path: 'ads_group', as: 'ads_group'
    member do
      post 'publish'
      post 'expire'
      delete 'clear_daily_tracking'
    end

    collection do
      post :actual_budget
      get :list
    end
  end

  resources :publishers do
    member do
      post 'publish'
      post 'expire'
    end
  end

  resources :advertisers do
    member do
      post 'publish'
      post 'expire'
    end
  end

  resources :campaign_group_stats, only: [] do
    collection do
      get ':campaign_id', to: 'campaign_group_stats#index', as: 'index'
      get ':campaign_id/group_detail/:group_id', to: 'campaign_group_details#index', as: 'detail'
      get ':campaign_id/notify_to_finance' => 'campaign_group_stats#notify', as: 'notify'
    end
  end

  resources :campaign_location_stats, only: [] do
    collection do
      get ':campaign_id', to: 'campaign_location_stats#index', as: 'index'
    end
  end

  resources :campaign_pacing_health_stats, only: [] do
    collection do
      get ':campaign_id', to: 'campaign_pacing_stats#index', as: 'index'
    end
  end

  resources :campaign_os_stats, only: [] do
    collection do
      get ':campaign_id', to: 'campaign_os_stats#index', as: 'index'
    end
  end

  resources :campaign_device_stats, only: [] do
    collection do
      get ':campaign_id', to: 'campaign_device_stats#index', as: 'index'
    end
  end

  resources :campaign_creative_stats, only: [] do
    collection do
      get ':campaign_id', to: 'campaign_creative_stats#index', as: 'index'
    end
  end

  resources :campaign_app_stats, only: [] do
    collection do
      get ':campaign_id', to: 'campaign_app_stats#index', as: 'index'
    end
  end

  # this routes use when campaign don't has ads group
  resources :campaign_details, only: [] do
    collection do
      get ':campaign_id', to: 'campaign_group_details#index', as: 'index'
    end
  end

  resources :campaign_reports, only: [] do
    member do
      get 'export'
      get 'export_as_agency'
    end
  end

  resources :country_costs do
    collection do
      get :list
    end
  end
  resources :daily_est_imps
  resources :banner_sizes do
    collection do
      get :list
    end
  end
  resources :densities do
    collection do
      get :load_in_country
    end
  end

  devise_for :users,
             path: 'auth',
             path_names: {
                 sign_in: 'login',
                 sign_out: 'logout',
                 password: 'secret',
                 confirmation: 'verification',
                 unlock: 'unblock',
                 registration: 'register',
                 sign_up: 'sign_up'},
             controllers: {
                 sessions: 'users/sessions',
                 registrations: 'users/registrations',
                 passwords: 'users/passwords'
             }
  as :user do
    get 'auth/register/edit' => 'users/registrations#edit', :as => 'edit_user_registration'
    put 'auth/register' => 'users/registrations#update', :as => 'user_registration'
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
