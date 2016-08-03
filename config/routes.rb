TheTournament::Application.routes.draw do
  break if ARGV.join.include? 'assets:precompile'

  scope "(:locale)", shallow_path: "(:locale)", locale: /ja|en/ do
    root to: "static_pages#top"
    devise_for :users, :controllers => {
      :registrations => 'users/registrations'
    }
    resources :users

    # ケンガントーナメントのリダイレクト処置
    get  "/tournaments/157/(:title)" => redirect("/tournaments/464/", status: 301)
    resources :tournaments, shallow: true do
      get 'page/:page', action: :index, on: :collection
      resources :players
      match 'players/edit', to: 'players#edit_all', via: :get, as: :edit_players
      resources :games
      match 'games/edit', to: 'games#edit_all', via: :get, as: :edit_games
    end
    match 'tournaments/:id/upload', to: 'tournaments#upload', via: :get
    match 'tournaments/:id/(:title)', to: 'tournaments#show', via: :get, as: :pretty_tournament, constraints: {title: /[^\/]+/}
    match ':action', controller: :static_pages, via: :get

    scope :embed do
      match '/tournaments/:id', to: 'tournaments#embed', via: :get, as: :embed_tournament
    end
  end
end
