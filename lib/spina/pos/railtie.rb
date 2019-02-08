module Spina
  module Pos
    class Railtie < Rails::Railtie

      initializer "spina_shop.register_plugin" do
        Spina::Plugin.register do |plugin|
          plugin.name = "Kassa"
          plugin.namespace = "pos"
        end
      end

      initializer "spina_pos.assets.precompile" do |app|
        app.config.assets.precompile += %w(
          spina/pos/scannen.png 
          spina/pos/delete-pos.png 
          spina/pos/sunset@2x.png 
          spina/pos/sunrise@2x.png 
          spina/pos/cart@2x.png 
          spina/pos/printer@2x.png 
          spina/pos/delete@2x.png 
          spina/pos/printer.png
        )
      end

    end
  end
end