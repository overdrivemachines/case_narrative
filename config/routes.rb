# == Route Map
#
#                                   Prefix Verb   URI Pattern                                                                                       Controller#Action
#                         new_user_session GET    /users/sign_in(.:format)                                                                          users/sessions#new
#                             user_session POST   /users/sign_in(.:format)                                                                          users/sessions#create
#                     destroy_user_session DELETE /users/sign_out(.:format)                                                                         users/sessions#destroy
#                        new_user_password GET    /users/password/new(.:format)                                                                     users/passwords#new
#                       edit_user_password GET    /users/password/edit(.:format)                                                                    users/passwords#edit
#                            user_password PATCH  /users/password(.:format)                                                                         users/passwords#update
#                                          PUT    /users/password(.:format)                                                                         users/passwords#update
#                                          POST   /users/password(.:format)                                                                         users/passwords#create
#                 cancel_user_registration GET    /users/cancel(.:format)                                                                           users/registrations#cancel
#                    new_user_registration GET    /users/sign_up(.:format)                                                                          users/registrations#new
#                   edit_user_registration GET    /users/edit(.:format)                                                                             users/registrations#edit
#                        user_registration PATCH  /users(.:format)                                                                                  users/registrations#update
#                                          PUT    /users(.:format)                                                                                  users/registrations#update
#                                          DELETE /users(.:format)                                                                                  users/registrations#destroy
#                                          POST   /users(.:format)                                                                                  users/registrations#create
#                    new_user_confirmation GET    /users/confirmation/new(.:format)                                                                 users/confirmations#new
#                        user_confirmation GET    /users/confirmation(.:format)                                                                     users/confirmations#show
#                                          POST   /users/confirmation(.:format)                                                                     users/confirmations#create
#                          new_user_unlock GET    /users/unlock/new(.:format)                                                                       users/unlocks#new
#                              user_unlock GET    /users/unlock(.:format)                                                                           users/unlocks#show
#                                          POST   /users/unlock(.:format)                                                                           users/unlocks#create
#                       rails_health_check GET    /up(.:format)                                                                                     rails/health#show
#                             pwa_manifest GET    /manifest(.:format)                                                                               rails/pwa#manifest
#                                     root GET    /                                                                                                 home#index
#         turbo_recede_historical_location GET    /recede_historical_location(.:format)                                                             turbo/native/navigation#recede
#         turbo_resume_historical_location GET    /resume_historical_location(.:format)                                                             turbo/native/navigation#resume
#        turbo_refresh_historical_location GET    /refresh_historical_location(.:format)                                                            turbo/native/navigation#refresh
#                     chrome_devtools_json GET    /.well-known/appspecific/com.chrome.devtools.json(.:format)                                       chrome_devtools_rails/devtools#show

Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    passwords: "users/passwords",
    confirmations: "users/confirmations",
    unlocks: "users/unlocks",
    omniauth_callbacks: "users/omniauth_callbacks"
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  resources :cases, only: %i[index show]

  root "home#index"
end
