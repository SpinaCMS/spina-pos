module Spina
  module Shop
    Order.class_eval do
      belongs_to :shift, class_name: "Spina::Pos::Shift", optional: true

      attr_accessor :validate_shift

      validates :shift, presence: true, if: -> { validate_shift }

      def everything_valid?
        if pos?
          self.validate_shift = true
        else
          self.validate_details = true
          self.validate_stock = true
          self.validate_payment = true
          self.validate_delivery = true
        end
        valid?
      end
    
    end
  end
end