module ShiftCommerce
  module Rails
    class AlternateDomainConstraint < Struct.new(:primary_domain)
      def matches?(request)
        !request_for_primary_domain?(request)
      end

      private
      def request_for_primary_domain?(request)
        request.host == primary_domain ||
        request.headers["HTTP_FASTLY_ORIG_HOST"] == primary_domain
      end
    end
  end
end