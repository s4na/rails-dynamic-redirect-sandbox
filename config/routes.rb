Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get 'foo/:hoge_type/:hoge_id', to: redirect('/foo/%{hoge_type}/%{hoge_id}')
end
