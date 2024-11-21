class ProductPresenter
  def initialize(product)
    @product = product
  end

  def show
    begin
      if !@product.is_a?(Product) || @product.nil? || @product.blank?
        not_found_message
      else
        {
          data: {
            product_id: @product.product_id,
            value: format("%.2f", @product.value)
          },
          status: 200
        }
      end
    rescue StandardError => e
      Rails.logger.error("Error #{e.message}")
      error_message
    end
  end

  def show_all
    begin
      { data: { results: @product }, status: 200 }
    rescue StandardError => e
      Rails.logger.error("Error #{e.message}")
      error_message
    end
  end

  private
    def error_message
      { data: { error: "Internal server error." }, status:  500 }
    end

    def not_found_message
      { data: { message: "Product not found." }, status: 404 }
    end
end
