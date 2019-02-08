module Spina::Pos
  module Errors
    class CurrentShiftNotFound < StandardError; end
  end
end

module Spina
  module Pos
    class CheckoutController < PosController
      before_action :set_order, except: [:finished]
      before_action :raise_exception_if_empty_order, except: [:finished]
      before_action :raise_exception_if_no_active_shift

      rescue_from Errors::CurrentShiftNotFound, with: :render_shift_instructions
      rescue_from Shop::Errors::EmptyOrder, with: :render_empty_order

      def index
      end

      def update
        @order.update_attributes(order_params)
      end

      def confirm
        @received = BigDecimal.new(params[:payment_received].gsub(",", "."))
        if @received >= @order.to_be_paid || (@order.payment_method == 'cash' && @received >= @order.to_be_paid_round)
          @order.shift = current_shift
          @order.transition_to!(:confirming)
          @order.transition_to!(:received)
          @order.transition_to!(:paid)
          @order.transition_to!(:picked_up)
          @change = @received - @order.to_be_paid_round if @order.payment_method == 'cash'
        else
          render :not_confirmed
        end
      rescue Exception => e
        Rails.logger.info @order.pos.inspect
        Rails.logger.info @order.everything_valid?.inspect
        Rails.logger.info @order.order_items.any?.inspect
        Rails.logger.info @order.errors.full_messages
        Rails.logger.info e
        render :not_confirmed
      ensure
        session[:order_id] = nil
      end

      def cash_payment
      end

      def pin_payment
      end

      def finished
        @change = BigDecimal.new(params[:change]) if params[:change].present?
      end

      private

        def raise_exception_if_no_active_shift
          raise Errors::CurrentShiftNotFound unless current_shift
        end

        def raise_exception_if_empty_order
          raise Shop::Errors::EmptyOrder unless @order.order_items.any?
        end

        def render_shift_instructions
          render 'shift_instructions'
        end

        def render_empty_order
          render 'empty_order'
        end

        def set_order
          @order = current_order
        end

        def order_params
          params.require(:order).permit(:payment_method)
        end

    end
  end
end