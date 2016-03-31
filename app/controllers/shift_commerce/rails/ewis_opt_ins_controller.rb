module ShiftCommerce
  module Rails
    class EwisOptInsController < ApplicationController

      expose(:ewis_opt_in, model: FlexCommerce::EwisOptIn, attributes: :ewis_opt_in_params)

      def create
        if ewis_opt_in.save
          redirect_to :back, notice: I18n.t("ewis.subscribed")
        else
          redirect_to :back, notice: I18n.t("ewis.not_subscribed")
        end
      end



      private

      def ewis_opt_in_params
        params.require(:ewis_opt_in).permit(:variant_id, :customer_account_id,
          :email, :first_name, :last_name)
      end


    end
  end
end