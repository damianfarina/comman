module IdSearchQueryProcessor
  extend ActiveSupport::Concern

  included do
    before_action :process_id_search_query, if: -> { params[:q].present? }
  end

  private

    def process_id_search_query
      key = params[:q].keys.find { |k| k.match(/id_or/) }
      return if key.nil?

      new_key = key.sub(/^id_or_/, "")
      extracted_id = params[:q][key].match(/#(\d+)/)&.captures&.first&.to_i
      original_value = params[:q].delete(key)
      params[:q][new_key] = original_value.gsub(/#(\d+)/, "").strip
      params[:q]["id_eq"] = extracted_id if extracted_id.present?
    end
end
