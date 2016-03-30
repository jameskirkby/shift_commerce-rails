module ShiftCommerce
  module Rails
    class AccountSessionsController < ApplicationController
      expose(:account, model: "FlexCommerce::CustomerAccount", param_key: :account)
      def new
        self.page_title = t(".page_title")
      end

      def create
        self.account = FlexCommerce::CustomerAccount.authenticate(email: params[:account][:email], password: params[:account][:password])
        if account.nil?
          self.account = FlexCommerce::CustomerAccount.new(email: params[:account][:email], password: params[:account][:password])
          account.errors.add(:email, I18n.t("account_sessions.create.incorrect_email_or_password"))
          render :new
        elsif account.valid?
          redirect_to({action: :index, controller: :welcome}, alert: t("accounts.logged_in"))
          AccountSessionService.new.after_login(account, session, cart: open_cart)
        else
          render :new
        end
      end

      def destroy
        self.page_title = t(".page_title")
        session.delete(:account_id)
        AccountSessionService.new.after_logout(session)
      end
    end
  end
end