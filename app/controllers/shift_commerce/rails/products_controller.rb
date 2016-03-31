module ShiftCommerce
  module Rails
    class ProductsController < ApplicationController
      include ShiftCommerce::Rails::TemplateDefinitionHelper

      expose(:search_text) { params["q"] }
      expose(:filter)   { FlexCommerce::ParamToShql.new(params[:facet_filter]).call }
      expose(:product)  { FlexCommerce::Product.find(params[:id]) }
      expose(:products) { params[:q] ? query_scope : root_scope } 

      expose(:ewis_opt_in) { FlexCommerce::EwisOptIn.new }
      expose(:variant) {
        product.variants.first
      }

      def search
        if products.links.links["redirect_url"]
          redirect_to products.links.links["redirect_url"]
        else
          self.page_title = t(".page_title", search_text: search_text)

          render :index
        end
      end

      # Different from the product search.
      def facet_search
        render :index
      end

      def show
        expires_now
        self.page_title = product.title
        render_template_for(product)
      end

      private

      #
      # root_scope
      #
      def root_scope
        FlexCommerce::Product.where(filter: filter.to_json).all
      end

      #
      # query_scope
      #
      def query_scope
        FlexCommerce::Product.temp_search(
          query: search_text, 
          fields: "description,title,slug,reference,variants.sku,variants.reference",
          aggs:   "variants.meta.colour, variants.meta.material", 
          filter: filter.to_json)
      end

      def redirect_lookup_params
        if params[:id].present?
          { source_type: "products", source_slug: params[:id] }
        else
          super
        end
      end
    end
  end
end
