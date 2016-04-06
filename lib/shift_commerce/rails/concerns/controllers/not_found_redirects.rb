#
# NotFoundRedirects
#
# When a 404 is hit, we lookup possible redirects
#
module ShiftCommerce::Rails::Concerns::Controllers::NotFoundRedirects
  extend ActiveSupport::Concern

  included do
    rescue_from ::FlexCommerceApi::Error::NotFound, ActionController::RoutingError,
      with: :handle_page_not_found
  end

  # default handler for API lookup 404 Not Found responses
  def handle_page_not_found(exception = nil)
    redirect_params = redirect_lookup_params.merge(source_path: request.path)
    # attempt to locate a matching redirect
    redirect = FlexCommerce::Redirect.find_by_resource(redirect_params)
    # if found, build URL and redirect
    if redirect
      redirect_url = destination_for_redirect(redirect)
      redirect_to(redirect_url, status: redirect.status_code)
    else
      handle_not_found(exception)
    end
  # when redirects cannot be found, handle using regular 404 process
  rescue ::FlexCommerceApi::Error::NotFound => ex
    handle_not_found(exception)
  end

  # default behavior for handling not found errors, easily overridable and reusable
  def handle_not_found(exception = nil)
    raise(exception)
  end

  protected

  # receives a FlexCommerce::Redirect object and returns a path to redirect to
  def destination_for_redirect(redirect)
    case redirect.destination_type
    when "exact"
      redirect.destination_path
    when "products"
      product_path(id: redirect.destination_slug)
    when "static_pages"
      pages_path(slug: redirect.destination_slug)
    when "categories"
      category_products_path(category_tree_slug: "web", id: redirect.destination_slug)
    else
      raise NotImplementedError, "Unknown redirect type '#{redirect.destination_type}'\n  #{redirect.inspect}"
    end
  end

  private

  # to be overridden by resource-based controllers to pass source_type and source_slug
  def redirect_lookup_params
    {}
  end
end