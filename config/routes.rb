Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get 'foo/:hoge_type/:hoge_id', to: redirect('/foo/%{hoge_type}/%{hoge_id}')
  # Prefer annotated tokens (like `%<foo>s`) over template tokens (like `%{foo}`). (convention:Style/FormatStringToken)
  
  # 上記エラーを対応するために、以下のように修正するとエラーになる
  # get 'foo/:hoge_type/:hoge_id', to: redirect('/foo/%<hoge_type>s/%<hoge_id>s')
  # get 'foo/:hoge_type/:hoge_id', to: redirect('/foo/%<hoge_type>s/%<hoge_id>d')
end
