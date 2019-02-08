module Spina
  module Pos
    class SessionsController < PosController
      skip_before_action :authorize, only: [:new, :create]

      def new
      end

      def create
        user = User.where(email: params[:email]).first
        if user && user.authenticate(params[:password])
          cookies.signed.permanent[:user_id] = user.id
          user.update_last_logged_in!
          redirect_to spina_pos.products_url
        else
          flash.now[:alert] = I18n.t('spina.notifications.wrong_username_or_password')
          render "new"
        end
      end

      def destroy
        cookies.delete(:user_id)
        head 401
      end

    end
  end
end