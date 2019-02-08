module Spina
  module Pos
    class PosController < ActionController::Base
      before_action :authorize
      protect_from_forgery with: :exception

      private

        def current_user
          @current_user ||= User.where(id: cookies.signed[:user_id]).first if cookies.signed[:user_id]
        end
        helper_method :current_user

        def pos_preferences
          @pos_preferences ||= Preferences.where(user_id: @current_user.id).first_or_create
        end
        helper_method :pos_preferences

        def pos_customer
          @pos_customer ||= Shop::Customer.where(first_name: 'POS', last_name: 'Mr. Hop', email: 'info@mrhop.nl', country: Spina::Shop::Country.first).first_or_create
        end
        helper_method :pos_customer

        def current_shift
          @current_shift ||= Shift.open_shift.ordered.where(user: current_user).first
        end
        helper_method :current_shift

        def current_order
          @current_order ||= begin
            if has_order?
              @current_order
            else
              order = Shop::Order.where(store: Spina::Shop::Store.find_by(name: "SmokeSmarter"), customer: pos_customer, user_id: current_user.id, received_at: nil, pos: true, billing_country: Shop::Country.find_by(code: "NL"), prices_include_tax: true).order(created_at: :desc).first_or_create
              session[:order_id] = order.id
              order
            end
          end
        end
        helper_method :current_order

        def has_order?
          session[:order_id] && @current_order = Shop::Order.find_by_id(session[:order_id])
        end
        helper_method :has_order?

        def authorize
          head 401 unless current_user
        end
    end
  end
end