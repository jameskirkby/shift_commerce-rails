require_relative "../lib/shift_commerce/rails/alternate_domain_constraint"

ShiftCommerce::Rails::Engine.routes.draw do
  # note: this is overly verbose until a means of reloading routes between tests is found
  # this redirects non-primary domain requests to the primary domain
  get "(*all)",
    to: redirect { |params, request|
      request.url.gsub(request.host, ENV["PRIMARY_DOMAIN"])
    },
    constraints: lambda { |request|
      return false unless ENV["PRIMARY_DOMAIN"].present?
      AlternateDomainConstraint.new(ENV.fetch("PRIMARY_DOMAIN")).matches?(request)
    }

  # @TODO Alot of this is now duplicated in categories/show but perhaps not appropriate for use here ?
  resources :products, only: [:show] do
    collection do
      get :search
    end
  end

  #@TODO Rename method
  get "categories/:category_tree_slug/:id" => "categories#show", as: :category_products

  get "categories/:category_tree_slug/:category_id/facet_search" => "categories#facet_search", as: :facet_search

  get "pages/*slug", to: "static_pages#show", as: :pages

  resources :suggestive_search, only: [] do
    collection do
      get :search
    end
  end

  resources :ewis_opt_ins, only: :create

  resource :cart, only: [:show, :update, :edit] do
    get "/change", to: "carts#change"
    resources :line_items, only: [:create]
    resources :transactions, only: [:new, :create] do
      collection do
        get "/new/:gateway", action: "new_with_gateway", as: :new_with_gateway
        get "/new_with_token/:gateway", action: :new_with_token, as: :new_with_gateway_and_token
        get "/new_from_spreedly", action: :new_from_spreedly, as: :new_from_spreedly
        get "/new_from_secure_trading", action: :new_from_secure_trading, as: :new_from_secure_trading
        post "/declined_from_secure_trading", action: :declined_from_secure_trading, as: :declined_from_secure_trading
      end
    end
  end

  resources :orders, only: :show do
    member do
      get "confirmation/:id", action: :confirmation
    end
  end

  resource :account, only: [:create, :new, :edit, :update] do
    get "login", to: "account_sessions#new"
    post "login", to: "account_sessions#create"
    get "logout", to: "account_sessions#destroy"
    get "reset_password_request", to: "resets#new"
    post "reset_password_request", to: "resets#create"
    get "reset_password", to: "passwords#new", as: :new_reset_password
    post "reset_password", to: "passwords#create"
    resources :addresses
    resources :orders, only: :index
  end

  root 'welcome#index'

  get "*path", to: "application#handle_page_not_found"
end
