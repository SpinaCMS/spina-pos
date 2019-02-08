module Spina
  module Pos
    class OrdersController < PosController

      def new
        @order = current_order
        @order_items = @order.order_items.includes(:orderable).order(created_at: :desc)
      end

      def index
        @orders = Shop::Order.where(pos: true).received.order('received_at DESC').page(params[:page]).per(20)
      end

      def show
        @order = Shop::Order.find(params[:id])
      end

      def print
        @order = Shop::Order.find(params[:id])
      end

      def add_product
        # Raise order not building anymore if not building!
        product = Shop::Product.find(params[:product_id])

        @order_item = current_order.order_items.where(orderable: product).first_or_initialize
        @order_item.quantity = @order_item.quantity + 1
        @order_item.save && current_order.save
      rescue ActiveRecord::RecordNotFound 
        render :failed_to_add
      end

      def add_product_bundle
        product_bundle = Shop::ProductBundle.find(params[:product_bundle_id])

        @order_item = current_order.order_items.where(orderable: product_bundle).first_or_initialize
        @order_item.quantity = @order_item.quantity + 1
        @order_item.save && current_order.save
      rescue ActiveRecord::RecordNotFound
        render :failed_to_add
      end

      def scanned
        # Raise order not building anymore if not building!
        @order = current_order
        product_scan = params[:scan]
        item = Shop::Product.find_by!(ean: product_scan)
        @order_item = current_order.order_items.where(orderable: item).first_or_initialize
        @order_item.quantity = @order_item.quantity + 1
        @order_item.save && current_order.save
        render :add_product
      rescue ActiveRecord::RecordNotFound
        render :failed_to_add
      end

      def update
        # Raise order not building anymore if not building!
        @order = current_order
        @order.update_attributes(order_params)
      end

      def gift_card
        # Raise order not building anymore if not building!
        @order = current_order
      end

      def add_gift_card
        # Raise order not building anymore if not building!
        code = params[:gift_card].gsub(/\s|-/, "")
        gift_card = Shop::GiftCard.available.where(code: code).first

        if gift_card.present? && current_order.building?
          current_order.gift_card = gift_card
          current_order.save
        else
          render :failed_to_add_gift_card
        end
      end

      def remove_gift_card
        # Raise order not building anymore if not building!
        if current_order.building?
          current_order.gift_card = nil
          current_order.save
        end
      end

      def discount
        # Raise order not building anymore if not building!
        @order = current_order
      end

      def add_discount
        # Raise order not building anymore if not building!
        discount = Shop::Discount.where(code: params[:discount]).first

        if discount.present? && discount.active? && current_order.building?
          current_order.discount = discount
          current_order.save
        else
          render :failed_to_add_discount
        end
      end

      def remove_discount
        # Raise order not building anymore if not building!
        if current_order.building?
          current_order.discount = nil
          current_order.save
        end
      end

      private

        def order_params
          params.require(:order).permit(order_items_attributes: [:id, :quantity])
        end

    end
  end
end