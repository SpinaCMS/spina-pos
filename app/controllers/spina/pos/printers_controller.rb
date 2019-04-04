module Spina
  module Pos
    class PrintersController < PosController

      def show
      end

      def update
        pos_preferences.update_attributes(pos_preferences_params)
      end

      private

        def pos_preferences_params
          params.require(:preferences).permit(:printer_ip)
        end

    end
  end
end