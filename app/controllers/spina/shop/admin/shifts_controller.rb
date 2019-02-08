module Spina
  module Shop
    module Admin
      class ShiftsController < AdminController

        def index
          add_breadcrumb "Kassadiensten"
          @shifts = Pos::Shift.includes(:user).order(start_datetime: :desc)
        end

      end
    end
  end
end