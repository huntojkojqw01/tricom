Jpt::Application.routes.draw do
  get 'rorumenbas/new'

  get 'rorumasters/new'

  resources :yuusens do
    collection {get :export_csv}
    collection {post :import}
  end
  resources :setsubis do
    collection {post :import}
    collection {get :export_csv}
  end
  resources :settings do
    collection {post :import}
    collection {get :export_csv, :setting}
  end
  get 'kanris/index'

  get 'kanri/index'

  get 'helps' => 'helps#index'

  resources :kairans do
    collection {post :confirm, :kaitou_create}
    collection {get :shokairan}
    member {get :kaitou, :send_kairan_view}
    collection {get :export_csv}
  end

  resources :kairanyokenmsts do
    collection {get :export_csv}
    collection {post :import}
  end

  resources :kairanshosais do
    collection {get :export_csv}
    collection {post :import}
  end

  resources :tsushinseigyous do
    collection {get :export_csv}
    collection {post :import}
  end

  resources :dengonyoukens do
    collection {get :export_csv}
    collection {post :import}
  end

  resources :dengonkaitous do
    collection {get :export_csv}
    collection {post :import}
  end

  resources :dengons do
    collection {get :export_csv}
  end


  root to: 'main#index'
  get "login" => "sessions#new"
  post "login" => "sessions#create"
  delete "logout" => "sessions#destroy"

  resources :bashokubunmsts  do
    collection {post :import}
    collection {get :export_csv}
  end

  resources :bunruis do
    collection {post :import}
    collection {get :export_csv}
  end

  resources :shoninshamsts  do
    collection {post :import}
    collection {get :export_csv}
  end

  resources :ekis do
    collection {post :ajax, :import, :create_eki, :update_eki}
    collection {get :export_csv}
  end

  resources :kikanmsts do
    collection {post :import}
    collection {get :export_csv}
  end

  resources :kintais do
    collection {get :search}
    collection {get :export_csv}
  end

  resources :events, only: [:index, :new, :create, :edit, :update] do
		collection {post :ajax, :custom, :create_basho, :create_kaisha, :time_line_view}
    collection {get :time_line_view}
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
    collection {post :ajax, :import}
    collection {get :export_csv}
  end


  resources :jpt_holiday_msts do
    collection {post :ajax, :import}
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
    collection {post :import}
  end

  resources :yakushokumasters, param: :id do
    collection {post :ajax, :import}
    collection {get :export_csv}
  end

  resources :keihiheads do
    collection {post :ajax, :shonin_search}
    collection {get :shonin_search}
    collection {get :export_csv}
  end

  resources :keihibodies do
    collection {get :export_csv}
  end

  resources :shozokumasters do
    collection {post :import}
    collection {get :export_csv}
  end

  resources :joutaimasters do
    collection {post :import}
    collection {get :export_csv}
  end

  resources :kaishamasters, param: :id do
    collection { post :import}
    collection {get :export_csv}
  end

  resources :shozais do
    collection { post :import}
    collection {get :export_csv}
  end

  resources :setsubiyoyakus do
  end

  resources :rorumasters do
    collection { post :import}
    collection {get :export_csv}
  end

  resources :rorumenbas do
    collection { post :import}
    collection {get :export_csv}
  end

  constraints(:id => /\w+(,\w+)*/) do
    resources :kouteimasters do
      collection {post :ajax}
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
end
