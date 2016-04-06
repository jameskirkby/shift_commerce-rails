#
# HoldingPageProtection
#
# Limits access to the site when ENV['SITE_PASSWORD'] is set
#
module HoldingPageProtection

  protected
  
  def display_holding_page?
    current_site_password.present?
  end

  # handles the logic of displaying the holding page, unless a visitor has
  # passed the query param of 'site_password' with the valid password.
  # it will redirect to the root path, unless already there
  # if on the root path, it will render the public/holding_page.html file
  def handle_holding_page
    store_site_password
    apply_holding_page_cache

    if allow_through_backdoor?
      true # no-op
    elsif request.path == "/"
      render html: File.read(Rails.root.join("public/holding_page.html")).html_safe, status: 503
    else
      redirect_to root_url, status: 302
    end
  end

  # applies caching headers, so backdoors have no caching, and holding pages
  # are cached for 10 seconds (to reduce load)
  def apply_holding_page_cache
    if allow_through_backdoor?
      expires_now
    else
      expires_in 10.seconds, public: false
    end
  end

  # returns a boolean of whether we should allow the user through the backdoor
  def allow_through_backdoor?
    current_site_password == session[:site_password]
  end

  # returns the current site password
  def current_site_password
    ENV["SITE_PASSWORD"]
  end

  # stores the site password in a session
  def store_site_password
    if params[:site_password].present?
      session[:site_password] = params[:site_password]
    end
  end
end