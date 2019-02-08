Rails.application.routes.draw do
  mount Spina::Pos::Engine => "/spina-pos"
end
