module ShiftCommerce
  module Rails
    class StaticPagesController < ApplicationController
      include ShiftCommerce::Rails::TemplateDefinitionHelper
      expose(:static_page)

      def show
        self.static_page = ::FlexCommerce::StaticPage.find("slug:#{params[:slug]}")
        self.page_title = static_page.title
        render_template_for static_page
      end

      private def redirect_lookup_params
        if params[:slug].present?
          { source_type: "static_pages", source_slug: params[:slug] }
        else
          super
        end
      end
    end
  end
end

