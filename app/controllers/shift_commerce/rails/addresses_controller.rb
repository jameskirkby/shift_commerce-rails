module ShiftCommerce
  module Rails
    class AddressesController < ApplicationController
      expose(:addresses) { FlexCommerce::Address.where(customer_account_id: current_account.id) }
      expose(:address) do
        if params.key?(:id)
          FlexCommerce::Address.where(customer_account_id: current_account.id).find(params[:id]).first
        else
          FlexCommerce::Address.new
        end
      end
      expose(:countries) { FlexCommerce::Country.all }

      def new
        expires_now
        self.page_title = t(".page_title")
      end

      def create
        if address.update_attributes(address_params)
          redirect_to({action: :index}, alert: I18n.t("addresses.create.created"))
        else
          render :new
        end
      end

      def edit
        expires_now
        self.page_title = t(".page_title")
      end

      def update
        if address.update_attributes(address_params)
          redirect_to({action: :index}, alert: I18n.t("addresses.update.updated"))
        else
          render :edit
        end
      end

      def index
        expires_now
        self.page_title = t(".page_title")
      end

      def destroy
        address.path = { customer_account_id: current_account.id }
        if address.destroy
          redirect_to({ action: :index }, alert: I18n.t("addresses.destroy.destroyed"))
        end
      end

      private

      def address_params
        params.require(:address).permit(:first_name, :middle_names, :last_name, :address_line_1, :address_line_2, :address_line_3, :city, :state, :country, :postcode, :preferred_billing, :preferred_shipping).merge(customer_account_id: current_account.id)
      end

    end
  end
end