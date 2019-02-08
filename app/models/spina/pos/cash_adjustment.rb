module Spina
  module Pos
    class CashAdjustment < ApplicationRecord
      belongs_to :shift

      # A positive amount is an addition, a negative amount a subtraction
      validates :amount, presence: true
    end
  end
end