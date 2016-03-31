require "flex_commerce_api/api_base"

module ShiftCommerce
  module Rails
    class ApplicationController < ApplicationController::Base
      # include HoldingPageProtection
      # include NotFoundRedirects

      FASTLY_ORIGINAL_HOST = "HTTP_FASTLY_ORIG_HOST"
      # Prevent CSRF attacks by raising an exception.
      # For APIs, you may want to use :null_session instead.
      #include ShiftCommerce::Rails::CartHelper
      protect_from_forgery with: :exception
      helper_method :proxied_url_for

      # Check for the previewed state.
      around_action :handle_preview_state

      #
      # Here, we expose the current cart to the controllers and views.
      # the decent exposure gem will sort out caching this so we only fetch
      # it once per request no matter how many times we call open_cart
      expose(:open_cart) do
        begin
          if session.key?(:cart_id)
            FlexCommerce::Cart.find session[:cart_id]
          else
            account_id = current_account.present? ? current_account.id : nil
            FlexCommerce::Cart.create(relationships: {line_items: []}, customer_account_id: account_id).tap do |cart|
              session[:cart_id] = cart.id
            end
          end
        rescue ::FlexCommerceApi::Error::NotFound
          session.delete(:cart_id)
          retry
        end
      end
      
      expose(:page_title) { t("application_name") }

      expose(:current_account) do
        begin
          session.key?(:account_id) ? ::FlexCommerce::CustomerAccount.find(session[:account_id]) : nil
        rescue ::FlexCommerceApi::Error::NotFound
          session.delete(:account_id)
          retry
        end
      end

      # This method will be removed when devise is integrated
      def authenticate_account!
        raise NotAllowed unless current_account.present?
      end

      def original_host
        request.env.key?(FASTLY_ORIGINAL_HOST) ? request.env[FASTLY_ORIGINAL_HOST] : request.host
      end

      def proxied_url_for(url)
        url
      end
      deprecate proxied_url_for: "proxied_url_for is no longer required and will be removed by 31/3/2016.  Please remove it from your code base - it now does nothing"

      # this overrides NotFoundRedirects#handle_not_found to provide site-wide nice 404 pages
      def handle_not_found(exception = nil)
        render "shared/not_found", status: 404
      end

      protected

      def handle_preview_state
        if params[:preview].present?
          begin
            # Doing this is not particular pretty and raises a question to thread
            # safety of the underlying gem implementation. This MUST be addressed
            # later - FIXME
            FlexCommerceApi::ApiBase.reconfigure_all include_previewed: true
            yield
          ensure
            FlexCommerceApi::ApiBase.reconfigure_all
          end
        else
          yield
        end
      end
    end
  end
end

