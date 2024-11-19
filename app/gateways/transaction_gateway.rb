class TransactionGateway
  def show(id)
    Rails.cache.fetch("transaction_#{id}", expires_in: 600.seconds) do
      Transaction.find_by_id(id)
    end
  end

  def show_all
    Transaction.all
  end

  def create(order, product)
    Transaction.find_or_create_by(order_id: order.id, product_id: product.id)
  end

  def process_file(file)
    @order_gateway = OrderGateway.new
    @product_gateway = ProductGateway.new
    @user_gateway = UserGateway.new

      if file
        begin
          data = {}

            file.each_line do |line|
              user_id = line[0..9].strip.to_i
              user_name = line[10..54].strip
              order_id = line[55..64].strip.to_i
              product_id = line[65..74].strip.to_i
              product_value = line[75..86].strip
              date = Date.strptime(line[87..94].strip, "%Y%m%d").strftime("%Y-%m-%d")

              product = {
                "product_id" => product_id,
                "value" => format("%.2f", product_value)
              }

              unless data[user_id]
                data[user_id] = {
                  "user_id" => user_id,
                  "name" => user_name,
                  "orders" => {}
                }
              end

              @user_gateway.create(data[user_id])

              unless data[user_id]["orders"][order_id]
                data[user_id]["orders"][order_id] = {
                  "order_id" => order_id,
                  "products" => [],
                  "total" => "0.00",
                  "date" => date
                }
              end

              existing_product = data[user_id]["orders"][order_id]["products"].find { |p| p["product_id"] == product_id }

              if existing_product
                if product["value"].to_f > existing_product["value"].to_f
                  existing_product["value"] = format("%.2f", product_value)
                end
              else
                data[user_id]["orders"][order_id]["products"] << product
              end

              data[user_id]["orders"][order_id]["total"] = calculate_total(data[user_id]["orders"][order_id]["products"])

              product_create = @product_gateway.create(product, order_id)
              order = @order_gateway.create(data[user_id]["orders"][order_id], user_id)

              create(order, product_create)
            end

          transactions = mapper_all_transactions(data)

          transactions
        rescue StandardError => e
          Rails.logger.error "#{e}"
        end
      else
        Rails.logger.error "Empty data file"
      end
  end

  private

  def mapper_all_transactions(users)
    transactions_mapper = []

    transactions_mapper = users.values.map do |user|
      {
        "user_id" => user["user_id"],
        "name" => user["name"],
        "orders" => user["orders"].values.map do |order|
          {
            "order_id" => order["order_id"],
            "total" => format("%.2f", order["total"]),
            "products" => order["products"]
          }
        end
      }
    end

    transactions_mapper
  end

  def calculate_total(products)
    total = 0.00

    products.each do |product|
      total += product["value"].to_f
    end

    total_order = format("%.2f", total)
    total_order
  end
end
