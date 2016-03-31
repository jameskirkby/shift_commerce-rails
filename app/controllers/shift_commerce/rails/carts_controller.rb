module ShiftCommerce
  module Rails
    class CartsController < ApplicationController
      expose(:cart) { open_cart.tap { |cart| cart.validate_stock! } }
      expose(:line_item) {
        cart.line_items.find(params[:line_item_id]) if params.key?(:line_item_id)
      }
      expose(:shipping_methods) { FlexCommerce::ShippingMethod.all }
      expose(:shipping_countries) { FlexCommerce::Country.where(allowed_shipping_countries: true).all }
      expose(:billing_countries) { FlexCommerce::Country.all }
      expose(:checkout_disabled) { cart.errors.present? || cart.line_items.any? { |li| li.errors.present? } }
      attr_accessor :shipping_address, :billing_address
      helper_method :shipping_address, :billing_address
      AddressModel = ::FlexCommerce::Address
      BillingAddressModel = ::FlexCommerce::Address
      ShippingAddressModel = ::FlexCommerce::Address

      def edit
        self.billing_address = BillingAddressModel.new
        self.shipping_address = ShippingAddressModel.new
        self.page_title = t(".page_title")
      end

      def show
        expires_now
        self.page_title = t(".page_title")
      end

      def update
        # Note this logic to act differently based on coupon code is temporary
        # as the coupon code will move to the cart/edit page (checkout)
        if params[:cart].key?(:coupon_code)
          coupon = FlexCommerce::Coupon.create(coupon_code: params[:cart][:coupon_code], path: {cart_id: cart.id})
          if coupon.persisted?
            redirect_to({action: :show}, alert: I18n.t("carts.show.coupon_applied"))
          else
            redirect_to({action: :show}, alert: coupon.errors.first.last)
          end
        else
          if update_cart
            redirect_to(action: :new, controller: :transactions)
          else
            render :edit
          end

        end
      end

      # @TODO Review this with the team - this is the result of a previous discussion with
      # regards to changing line item quantity to zero which isnt allowed in the API.
      def change
        expires_now
        result = if line_item.present?
                   if params[:quantity].to_i < 1
                     line_item.destroy
                     true
                   else
                     line_item.unit_quantity = params[:quantity].to_i
                     line_item.save
                   end
                 else
                   true
                 end
        if result
          redirect_to({action: :show}, alert: I18n.t("carts.show.update"))
        else
          redirect_to({action: :show}, flash: {error: line_item.errors.messages.values.flatten.join(" , ")})
        end
      end

      private

      def update_cart
        find_or_create_addresses
        update_addresses
        return false unless addresses_valid?
        cart.update_attributes(cart_params.merge(billing_address_id: billing_address.id, shipping_address_id: shipping_address.id))
      end

      def addresses_valid?
        billing_address.errors.empty? && shipping_address.errors.empty?
      end

      def find_or_create_addresses
        find_or_create_shipping_address
        find_or_create_billing_address
      end

      def update_addresses
        update_billing_address
        update_shipping_address
      end

      def find_or_create_billing_address
        if cart_params[:billing_address_id].present?
          self.billing_address = AddressModel.where(customer_account_id: current_account.id).find(cart_params[:billing_address_id]).first
        else
          self.billing_address = AddressModel.create(billing_address_params.merge(account_params))
        end
      end

      def update_billing_address
        billing_address.update_attributes(billing_address_params) if allow_edit_billing_address
      end

      def find_or_create_shipping_address
        if cart_params[:shipping_address_id].present?
          self.shipping_address = AddressModel.where(customer_account_id: current_account.id).find(cart_params[:shipping_address_id]).first
        else
          self.shipping_address = AddressModel.create(shipping_address_params.merge(account_params))
        end
      end

      def update_shipping_address
        shipping_address.update_attributes(shipping_address_params) if allow_edit_shipping_address
      end

      def account_params
        current_account.present? ? {customer_account_id: current_account.id} : {}
      end

      def shipping_address_params
        # As the address can store any fields, then we permit them all
        params[:cart].require(:shipping_address_attributes).permit!
      end

      def billing_address_params
        # As the address can store any fields, then we permit them all
        params[:cart].require(:billing_address_attributes).permit!
      end

      def cart_params
        params.require(:cart).slice(:billing_address_id, :shipping_address_id, :shipping_method_id, :email)
      end

      def allow_edit_shipping_address
        params[:cart][:allow_edit_shipping_address] == "1"
      end

      def allow_edit_billing_address
        params[:cart][:allow_edit_billing_address] == "1"
      end

    end
  end
end