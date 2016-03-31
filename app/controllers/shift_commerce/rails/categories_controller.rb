module ShiftCommerce
  module Rails
    class CategoriesController < ApplicationController
      include ShiftCommerce::Rails::TemplateDefinitionHelper
      expose(:category) { params.key?(:id) ? FlexCommerce::Category.where(category_tree_id: "slug:#{params[:category_tree_slug]}").find("slug:#{params[:id]}").first : nil }

      expose(:filter)   { FlexCommerce::ParamToShql.new(params[:facet_filter]).call }
      expose(:products) { root_scope }

      # GET /categories/:id
      def show
        expires_now
        self.page_title = "Products in #{category.title}"
        render_template_for category
      end

      # Different from the product search.
      def facet_search
        render :show
      end

      #
      # END OF PUBLIC INTERFACE
      #

      private

      #
      # root_scope
      #
      def root_scope
        FlexCommerce::Product.where(
          category_tree_id: "slug:#{params["category_tree_slug"]}", 
          category_id:      "slug:#{params["id"]}", 
          filter: filter.to_json
        ).all
      end

      def redirect_lookup_params
        if params[:id].present?
          { source_type: "categories", source_slug: params[:id] }
        else
          super
        end
      end
    end
  end
end