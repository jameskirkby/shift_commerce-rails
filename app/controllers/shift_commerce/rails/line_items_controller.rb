module ShiftCommerce
  module Rails
    class LineItemsController < ApplicationController
      # @TODO Re enable authenticity token once front end form is done correctly
      skip_before_action :verify_authenticity_token

      expose(:line_item) do
        case params[:action]
        when 'create' then ::FlexCommerce::LineItem.new(input_params)
        else ::FlexCommerce::LineItem.find(params[:id])
        end
      end

      def create
        # @TODO Convert the form on the front end to use rails helpers
        if line_item.save
          redirect_to :back, notice: t('added_to_basket')
        else
          redirect_to :back, flash: {error: line_item.errors.messages.values.flatten.join(" , ")}
        end
        # @TODO Caution - if the server comes back with a 422 (when the item_id was missing) it appeared to have saved - no error messages.  But, line_item.presisted? was false
      end

      private

      def input_params
        # @TODO Change this to suit polymorphic arrangement
        item = FlexCommerce::Variant.new(id: params[:variant_id])
        params.require(:line_item).permit(:unit_quantity, :variant_id, :item_id, :item_type).merge(container_id: open_cart.id)
      end
    end
  end
end