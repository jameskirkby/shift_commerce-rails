module ShiftCommerce
  module Rails
    class SuggestiveSearchController < ApplicationController
      # Called from an ajax method

      def search

        search_suggestions = FlexCommerce::SearchSuggestion.where(text_to_match: params[:suggestion], field: 'title')

        suggestions = search_suggestions.map { |ss| ss.text}

        respond_to do |format|
          format.js { render json: suggestions }
        end

      end

    end
  end
end
