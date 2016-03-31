module ShiftCommerce
  module Rails
    class TransactionsController < ApplicationController
      helper ShiftCommerce::SecureTrading::Engine.helpers
      include ShiftCommerce::UiPaymentGateway::ControllerExtensions
      include ShiftCommerce::SecureTrading::ControllerExtensions

      expose(:cart) { open_cart }
      expose(:payment_providers) { FlexCommerce::PaymentProvider.where(installed: true) }

      def on_order_created(order, iframed: false)
        session.delete(:cart_id)
        if iframed
          render :redirect_parent_to_order, layout: false, locals: {order: order}
        else
          redirect_to action: :confirmation, id: order.id, controller: "orders"
        end
      end

      def on_order_validation_failed(order, iframed: false)
        if iframed
          flash[:error] = order.errors.full_messages
          render :redirect_parent_to_new_transaction, layout: false
        else
          redirect_to action: :new
        end
      end

      def on_payment_declined(params, iframed: false)
        flash[:alert] = I18n.t("transactions.new.payment_declined")
        if iframed
          render :redirect_parent_to_new_transaction, layout: false
        else
          redirect_to action: :new
        end
      end
      
      # @TODO Remove the scheme restriction below once problem is solved with redirects back from paypal
      def success_url
        url_for(action: :new_with_token, host: original_host, protocol: :http).gsub(/^https/, "http").tap do |r|
          Rails.logger.warn "Success url was #{r}"
        end
      end

      # @TODO Remove the scheme restriction below once problem is solved with redirects back from paypal
      def cancel_url
        url_for(action: :new, host: original_host, protocol: :http).gsub(/\/transactions\/new$/, '').gsub(/^https/, "http").tap do |r|
          Rails.logger.warn "Cancel url was #{r}"
        end
      end

      # Spreedly specific - to go into gem
      # @TODO Move into gem
      # @TODO Get currency from somewhere ?
      def new_from_spreedly
        gateway_response = { token: params[:payment_setup][:payment_method_token] }
        txn = {
          gateway_response: gateway_response,
          amount: cart.total,
          currency: "GBP",
          transaction_type: "authorisation",
          # @TODO The gateway reference should maybe come from the  original setup ?  This way, it doesnt need separate maintenance from the API code
          payment_gateway_reference: "spreedly",
          status: "received"
        }
        order = order_model.create(cart_id: cart.id, transaction_attributes: txn, order_ip_address: request.ip )
        on_order_created(order)
      end

    end
  end
end