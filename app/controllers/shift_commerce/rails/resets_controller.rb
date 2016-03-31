module ShiftCommerce
  module Rails
    class ResetsController < ApplicationController
      def new
        self.page_title = I18n.t("accounts.reset_password_request")
      end
      def create
        # Note the use of original_host which fetches the original host sent to the proxy - if not proxies then just returns the host as normal
        FlexCommerce::CustomerAccount.generate_token(email: params[:reset][:email], reset_link_with_placeholder: new_reset_password_account_url(host: original_host, email: "{{email}}", reset_password_token: "{{token}}"))
      rescue FlexCommerceApi::Error::NotFound

      end
    end
  end
end