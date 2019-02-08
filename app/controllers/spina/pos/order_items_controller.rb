module Spina
  module Pos
    class OrderItemsController < PosController
      before_action :set_order

      def destroy
        @order_item = @order.order_items.find(params[:id])
        @order_item.destroy && @order.save
      end

      private

        def set_order
          @order = current_order
        end
    end
  end
end