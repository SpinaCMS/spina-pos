module Spina
  module Pos
    class ProductCategoriesController < PosController

      def show
        @product_category = Shop::ProductCategory.find(params[:id])
        @products = @product_category.products.includes(:product_images).order(created_at: :desc).page(params[:page]).per(20)

        respond_to do |format|
          format.html
          format.js { render template: 'spina/pos/products/index' }
        end
      end

    end
  end
end