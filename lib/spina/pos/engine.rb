require 'spina'

module Spina
  module Pos
    class Engine < ::Rails::Engine
      isolate_namespace Spina::Pos
    end
  end
end
