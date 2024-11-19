class TransactionPresenter
  def initialize(transaction)
    @transaction = transaction
  end

  def as_json
    puts @transaction
    @transaction.map do |transaction|
      mapper_transaction(transaction)
    end
  end

  def show
    begin
      if @transaction.is_a?(Transaction) || @transaction.nil? || @transaction.blank? 
        not_found_message
      else
        { data: @transaction, status: 200 }
      end
    rescue StandardError => e
      Rails.logger.error("Error #{e.message}")
      error_message
    end
  end

  def show_all
    begin
      { data: @transaction, status: 200 }
    rescue StandardError => e
      Rails.logger.error("Error #{e.message}")
      error_message
    end
  end

  private

  def mapper_transaction(transaction)
    {
      'user_id' => transaction['user_id'],
      'name' => transaction['name'],
      'orders' => transaction['orders'].map do |order|
        {
          'order_id' => order['order_id'],
          'total' => order['total'],
          'products' => mapper_product(order['products'])
        }
      end
    }
  end

  def mapper_product(products)
    products.map do |product|
      {
        'product_id' => product['product_id'],
        'value' => product['value']
      }
    end
  end

  def error_message
    { data: { error: 'Internal server error.' }, status:  500 }
  end

  def not_found_message
    { data: { message: 'Product not found' }, status: 404 }
  end
end