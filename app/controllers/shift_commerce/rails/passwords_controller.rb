module ShiftCommerce
  module Rails
    class PasswordsController < ApplicationController
      expose(:password) { Password.new }

      def new
        self.page_title = I18n.t("accounts.reset_password")
        password.email = params[:email]
        password.reset_password_token = params[:reset_password_token]
      end

      def create
        if FlexCommerce::CustomerAccount.reset_password(password_params)
          redirect_to({action: :new, controller: :account_sessions}, alert: I18n.t("accounts.password_changed"))
        else
          render :new
        end
      end

      private

      def password_params
        params.require(:password).permit(:password, :email, :reset_password_token)
      end
    end
  end
end