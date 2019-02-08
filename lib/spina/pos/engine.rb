require 'spina'

module Spina
  module Pos
    class Engine < ::Rails::Engine
      isolate_namespace Spina::Pos

      # Load decorators
      config.to_prepare do
        Dir.glob(Engine.root + "app/decorators/**/*_decorator*.rb").each do |decorator|
          require_dependency(decorator)
        end
      end
    end
  end
end
