module Spina
  module Pos
    class ProductBundlesController < PosController

      def index
        @product_bundles = Shop::ProductBundle.all
      end

      def show
        @product_bundle = Shop::ProductBundle.find(params[:id])
      end

    end
  end
end