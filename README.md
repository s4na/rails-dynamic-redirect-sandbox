# Sendagaya.rbで相談した、 routing error に関する sample code

`route.rb` のコードに相談内容が書いてあります。

```rb
Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get 'foo/:hoge_type/:hoge_id', to: redirect('/foo/%{hoge_type}/%{hoge_id}')
  # Prefer annotated tokens (like `%<foo>s`) over template tokens (like `%{foo}`). (convention:Style/FormatStringToken)
  
  # 上記エラーを対応するために、以下のように修正するとエラーになる
  # get 'foo/:hoge_type/:hoge_id', to: redirect('/foo/%<hoge_type>s/%<hoge_id>s')
  # get 'foo/:hoge_type/:hoge_id', to: redirect('/foo/%<hoge_type>s/%<hoge_id>d')
end
```

以下、Sendagaya.rb でのメモ

https://guides.rubyonrails.org/routing.html#redirection

format使ってるかわからない
使ってないかも

Rail 独自の記法かも？


https://github.com/rails/rails/blob/070d4afacd3e9721b7e3a4634e4d026b5fa2c32c/actionpack/lib/action_dispatch/routing/redirection.rb#L83


https://rubular.com/r/l8SYzXdkKnhuMz


Match groups: 1に入るので、

https://github.com/rails/rails/blob/070d4afacd3e9721b7e3a4634e4d026b5fa2c32c/actionpack/lib/action_dispatch/routing/redirection.rb#L85

に入る

```rb
def path(params, request)
        if block.match(URL_PARTS)
          path     = interpolation_required?($1, params) ? $1 % escape_path(params)     : $1 # 👈ここ
          query    = interpolation_required?($2, params) ? $2 % escape(params)          : $2
          fragment = interpolation_required?($3, params) ? $3 % escape_fragment(params) : $3

          "#{path}#{query}#{fragment}"
        else
          interpolation_required?(block, params) ? block % escape(params) : block
        end
      end
```

デリミタをEspaceしている（slashなど）

https://www.rubydoc.info/github/bbatsov/RuboCop/RuboCop/Cop/Style/FormatStringToken

## 原因はこれ

https://github.com/rails/rails/blob/070d4afacd3e9721b7e3a4634e4d026b5fa2c32c/actionpack/lib/action_dispatch/routing/redirection.rb#L101

```rb
      private
        def interpolation_required?(string, params)
          !params.empty? && string && string.match(/%\{\w*\}/) # 👈 ここに `{}` があるので、入ってなくてダメみたい
        end
```

いたずらしようとすると、これで動いちゃうことが判明😢

```rb
get 'foo/:hoge_type/:hoge_id', to: redirect('/foo/%{hoge_type}/%<hoge_id>d')
```

## Rails Guidesの通りに書くと、Rubocopエラーになるという話はある

## Rubocopでの回答

https://github.com/rubocop-hq/rubocop/issues/4425#issuecomment-342472069

## 本件に関連したissue

https://github.com/rubocop-hq/rubocop/issues/7452

https://github.com/rubocop-hq/rubocop/issues/4425
