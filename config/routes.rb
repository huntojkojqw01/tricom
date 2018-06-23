Jpt::Application.routes.draw do
  Rails.application.routes.draw do

  resources :tasks do
    put :sort, on: :collection
    collection {post :change_status, :ajax}
  end
end
  get 'rorumenbas/new'

  get 'rorumasters/new'

  resources :conversations do
    collection {post :update_message}
    resources :messages
  end
  resources :yuusens do
    collection {get :export_csv}
    collection {post :import, :ajax}
  end
  resources :paths do
    collection {get :export_csv}
    collection {post :import}
  end
  resources :setsubis do
    collection {post :import, :ajax, :create_setsubi, :update_setsubi}
    collection {get :export_csv}
  end
  resources :settings do
    collection {post :import, :ajax}
    collection {get :export_csv, :setting}
  end
  get 'kanris/index'

  get 'kanri/index'
  get 'main/search'
  get 'helps' => 'helps#index'
  get 'edit_help' => 'helps#edit_help'
  post 'helps' => 'helps#index'

  resources :kairans do
    collection {post :confirm, :kaitou_create}
    collection {get :shokairan}
    member {get :kaitou, :send_kairan_view}
    collection {get :export_csv}
  end

  resources :kairanyokenmsts do
    collection {get :export_csv}
    collection {post :import, :ajax, :create_kairanyoken, :update_kairanyoken}
  end

  resources :kairanshosais do
    collection {get :export_csv}
    collection {post :import}
  end

  resources :tsushinseigyous do
    collection {get :export_csv}
    collection {post :import, :ajax, :create_tsushinseigyou, :update_tsushinseigyou}
  end

  resources :dengonyoukens do
    collection {get :export_csv}
    collection {post :import, :ajax, :create_dengonyouken, :update_dengonyouken}
  end

  resources :dengonkaitous do
    collection {get :export_csv}
    collection {post :import, :ajax, :create_dengonkaitou, :update_dengonkaitou}
  end

  resources :dengons do
    collection {get :export_csv}
  end

  resources :main, only: [:index] do
    collection {get :search}
    collection {post :ajax}
  end

  get "login" => "sessions#new"
  post "login" => "sessions#create"
  delete "logout" => "sessions#destroy"
  get "confirm" => "sessions#send_mail"
  post "confirm" => "sessions#confirm_mail"
  get "login_code" => "sessions#login_code"
  post "login_code" => "sessions#login_code_confirm"
  resources :bashokubunmsts  do
    collection {post :import, :ajax, :create_bashokubunmst, :update_bashokubunmst}
    collection {get :export_csv}
  end

  resources :bunruis do
    collection {post :import, :ajax, :create_bunrui, :update_bunrui}
    collection {get :export_csv}
  end

  resources :shoninshamsts  do
    collection {post :import, :ajax, :create_shonin}
    collection {get :export_csv}
  end

  resources :ekis do
    collection {post :ajax, :import, :create_eki, :update_eki}
    collection {get :export_csv}
  end

  resources :kikanmsts do
    collection {post :import, :ajax, :create_kikan, :update_kikan}
    collection {get :export_csv}
  end

  resources :kintais do
    collection {get :search,:pdf_show,:sumikakunin}
    collection {post :import, :ajax}
    collection {get :export_csv}
  end

  resources :events, only: [:index, :new, :create, :edit, :update] do
		collection {post :ajax, :custom, :create_mybasho,:create_basho,:update_basho, :create_kaisha,:update_kaisha, :create_job, :update_job, :time_line_view, :import, :shutchou_create}
    collection {get :time_line_view, :pdf_event_show, :pdf_job_show, :pdf_koutei_show, :shutchou_ikkatsu_new}
    collection {get :export_csv}
	end

  resources :bashomasters do
    collection {post :ajax, :import}
    collection {get :export_csv}
  end
  resources :mybashomasters do
    collection {post :ajax, :import}
    collection {get :export_csv}
  end

  resources :shainmasters do
    collection {post :ajax, :import, :multi_delete}
    collection {get :export_csv}
  end


  resources :jpt_holiday_msts do
    collection {post :ajax, :import, :create_holiday, :update_holiday}
    collection{get :export_csv}
  end

  resources :jobmasters do
    collection {post :ajax, :import}
    collection {get :export_csv}
  end
  resources :myjobmasters do
    collection {post :ajax, :import}
    collection {get :export_csv}
  end

	match 'main', to: 'main#index', via: [:get]

  resources :users do
    collection {get :change_pass}
    collection {post :change_pass}
    collection {get :export_csv}
    collection {post :ajax, :import}
  end

  resources :yakushokumasters do
    collection { post :import }
    collection { get :export_csv }
  end

  resources :keihiheads do
    collection {post :ajax, :shonin_search, :import}
    collection {get :shonin_search, :pdf_show, :show_keihi_shuppi,:pdf_show_keihi_shuppi, :pdf_show_index}
    collection {get :export_csv}
  end

  resources :keihibodies do
    collection {get :export_csv}
  end

  resources :shozokumasters do
    collection { post :import }
    collection { get :export_csv }
  end

  resources :joutaimasters do
    collection {post :import, :multi_delete, :ajax, :create_joutai, :update_joutai}
    collection {get :export_csv}
  end

  resources :kaishamasters, param: :id do
    collection { post :import, :ajax, :create_kaisha, :update_kaisha}
    collection {get :export_csv}
  end

  resources :shozais do
    collection { post :import, :ajax}
    collection {get :export_csv}
  end

  resources :setsubiyoyakus do
    collection {post :import,:ajax}
    collection {get :export_csv}
  end

  resources :rorumasters do
    collection { post :import, :ajax, :multi_delete, :create_roru, :update_roru}
    collection {get :export_csv}
  end

  resources :yuukyuu_kyuuka_rirekis do
    collection { post :import, :ajax}
    collection {get :export_csv}
  end

  resources :rorumenbas do
    collection { post :import}
    collection {get :export_csv}
  end

  constraints(:id => /\w+(,\w+)*/) do
    resources :kouteimasters do
      collection {post :ajax,:multi_delete, :create_koutei, :update_koutei}
      collection{post :import}
      collection {get :export_csv}
    end
  end

  resources :export_csv, only: :index

  namespace :kanris do
    root to: "main#index"
    resources :kintais, only: [:index, :show] do
      collection {get :export_excel}
    end
    resources :keihiheads, only: :index
  end
  resources :kintaiteeburus do
    collection {post :import,:ajax}
  end
  root to: 'main#index'
end
