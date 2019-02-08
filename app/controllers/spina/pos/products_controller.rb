module Spina
  module Pos
    class ProductsController < PosController

      def index
        @products = Shop::Product.active.roots.includes(:product_images).order(created_at: :desc).page(params[:page]).per(20)
        @products = @products.search(params[:search]) if params[:search].present?
      end

      def show
        @product = Shop::Product.where(archived: false).find(params[:id])
      end

      def search
        @products = Shop::Product.active.roots.includes(:product_images).page(params[:page]).per(20)
        @products = @products.search(params[:search]) if params[:search].present?
      end

    end
  end
end