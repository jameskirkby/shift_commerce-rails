module ShiftCommerce
  module Rails
    class OrdersController < ApplicationController
      expose(:customer_account) { FlexCommerce::CustomerAccount.find(current_account.id) }
      expose(:orders, model: FlexCommerce::Order) { customer_account.orders.sort_by(&:date) }
      expose(:order, model: FlexCommerce::Order)


      #
      # GET /account/orders
      #
      def index
        self.page_title = I18n.t("orders.index.page_title")
      end

      #
      # GET /account/order/:id
      #
      def show
        self.page_title = I18n.t("orders.show.page_title")
      end

      def confirmation
        self.page_title = I18n.t("orders.confirmation.page_title")
      end
    end
  end
end