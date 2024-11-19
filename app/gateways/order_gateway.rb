class OrderGateway
  def show(id) 
    Rails.cache.fetch("order_#{id}", expires_in: 600.seconds) do
      Order.includes(:user, :products).find_by_id(id)
    end
  end

  def create(order_params, user_id)
    order = Order.find_or_create_by(id: order_params["order_id"])
    edit_order(order, order_params, user_id)

    order.save ? order : order.errors.full_messages
  end

  def search(start_date, end_date)
    Order.where(date: start_date..end_date)
  end

  def show_all
    Order.includes(:products, :user).all
  end

  private

  def edit_order(order, order_params, user_id)
    order.user_id = user_id        
    order.total = order_params["total"]
    order.date = order_params["date"]
  end
end