module Spina
  module Pos
    class ShiftsController < PosController
      before_action :check_current_shift, only: [:new, :create]

      def new
        @opening_balance = Shift.where(user_id: current_user.id).closed.ordered.first.try(:cash_left) || BigDecimal(0)
        @shift = Shift.new(opening_balance: @opening_balance)
      end

      def create
        @shift = Shift.new(shift_params)

        if @shift.save
          render js: "Turbolinks.visit('/turbolinks/back');"
        else
          render :new
        end
      end

      def edit
        @shift = current_shift
        @expected_balance = @shift.current_balance
      end

      def update
        @shift = current_shift

        if @shift.close_shift(cash_counted: close_params[:cash_counted], cash_left: close_params[:cash_left], note: close_params[:note])
          render js: "Turbolinks.visit('/turbolinks/back');"
        else
          render :edit
        end
      end

      private

        def check_current_shift
          raise Exception if current_shift.present?
        end

        def shift_params
          params.require(:shift).permit(:opening_balance).delocalize({opening_balance: :number}).merge(user_id: current_user.id, start_datetime: Time.zone.now)
        end

        def close_params
          params.require(:shift).permit(:cash_counted, :cash_left, :note).delocalize({cash_counted: :number, cash_left: :number})
        end

    end
  end
end