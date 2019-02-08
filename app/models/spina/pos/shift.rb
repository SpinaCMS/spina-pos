module Spina
  module Pos
    class Shift < ApplicationRecord
      belongs_to :user
      # has_many :cash_adjustments, dependent: :destroy
      has_many :orders, class_name: "Spina::Shop::Order", dependent: :restrict_with_exception

      validates :start_datetime, :opening_balance, presence: true

      validates :opening_balance, :cash_counted, :cash_left, numericality: true

      scope :open_shift, -> { where(end_datetime: nil) }
      scope :closed, -> { where.not(end_datetime: nil) }
      scope :ordered, -> { order(start_datetime: :desc) }

      def open?
        !closed?
      end

      def closed?
        end_datetime.present?
      end

      def current_balance
        opening_balance + orders.paid.sum(:total_cash)
      end

      def cash_difference
        cash_counted - cash_expected
      end

      def close_shift(cash_counted:, cash_left:, note:)
        update_attributes(
          cash_counted: cash_counted, 
          cash_left: cash_left, 
          cash_expected: current_balance, 
          end_datetime: Time.zone.now,
          note: note
        )
      end
    end
  end
end
