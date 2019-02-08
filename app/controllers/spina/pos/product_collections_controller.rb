module Spina
  module Pos
    class ProductCollectionsController < PosController

      def index
        @product_collections = Shop::ProductCollection.all
        @product_categories = Shop::ProductCategory.order(:name)
      end

      def show
        @product_collection = Shop::ProductCollection.find(params[:id])
        @products = @product_collection.products.includes(:product_images).order(:name).page(params[:page]).per(20)

        respond_to do |format|
          format.html
          format.js { render template: 'spina/pos/products/index' }
        end
      end

    end
  end
end