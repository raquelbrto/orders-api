class OrderPresenter
  def initialize(order)
    @order = order
  end

  def show
    begin
      if !@order.is_a?(Order) || @order.nil? || @order.blank?
        not_found_message
      else
        { data: order_info, status: 200 }
      end
    rescue StandardError => e
      Rails.logger.error("Error #{e.message}")
      error_message
    end
  end

  def show_all
    begin
      order_mapper = @order.map do |order|
        order_info(order)
      end
      { data: order_mapper, status: 200 }
    rescue StandardError => e
      Rails.logger.error("Error #{e.message}")
      error_message
    end
  end

  private

    def order_info(order = @order)
      {
        order_id: order.id,
        date: order.date,
        total: format("%.2f", order.total),
        user: user_info(order.user),
        products: products_info(order)
      }
    end

    def user_info(user)
      {
        user_id: user.id,
        name: user.name
      }
    end

    def products_info(order)
      order.products.map do |product|
        {
          product_id: product.product_id,
          value: format("%.2f", product.value)
        }
      end
    end

    def error_message
      { data: { error: "Internal server error." }, status:  500 }
    end

    def not_found_message
      { data: { message: "Order not found" }, status: 404 }
    end
end
