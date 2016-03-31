module ShiftCommerce
  module Rails
    class AccountsController < ApplicationController
      before_action :authenticate_account!, except: [:login, :new, :create]
      expose(:account, model: "FlexCommerce::CustomerAccount", param_key: :account)

      def login
        self.page_title = t(".page_title")
      end

      def new
        self.page_title = t(".page_title")
      end

      def create
        account.reference ||= account.email.dasherize
        if account.save
          redirect_to({action: :index, controller: :welcome}, alert: [t("accounts.registered"), t("accounts.logged_in")])
          AccountSessionService.new.after_login(account, session, cart: open_cart)
        else
          render :new
        end
      end

      def edit
        self.account = current_account
        self.page_title = t(".page_title")
      end

      def update
        self.account = current_account
        if account.update_attributes(params[:account])
          redirect_to({action: :edit}, alert: t("accounts.edit.updated"))
        else
          render :edit
        end
      end
    end
  end
end