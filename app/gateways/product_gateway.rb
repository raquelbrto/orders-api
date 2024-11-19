class ProductGateway
  def show(id)
    Rails.cache.fetch("product_#{id}", expires_in: 600.seconds) do
      Product.find_by_id(id)
    end
  end

  def show_all
    Product.all
  end

  def create(product_params, order_id)
    product = Product.joins(:orders).where(orders: { id: order_id }, product_id: product_params["product_id"]).first

    if product.is_a?(Product)
      product.update(value: product_params["value"]) if product_params["value"].to_f > product.value
    else
      product = Product.create(product_id: product_params["product_id"], value: product_params["value"])
    end

    product
  end
end
