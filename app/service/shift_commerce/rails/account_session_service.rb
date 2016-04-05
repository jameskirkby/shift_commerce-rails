module ShiftCommerce
  module Rails
    class AccountSessionService
      def after_login(account, session, options = {})
        session[:account_id] = account.id
        account.cart.merge!(options[:cart]) unless options[:cart].empty? or !options.key?(:cart)
        session[:cart_id] = account.cart.id
      end

      def after_logout(session)
        session.delete("cart_id")
      end
    end
  end
end