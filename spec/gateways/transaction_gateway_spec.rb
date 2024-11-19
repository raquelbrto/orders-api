require 'rails_helper'

RSpec.describe TransactionGateway, type: :gateway do
  let(:user) { build(:user_response) }
  let(:order) { build(:order_response, user: user) }
  let(:product) { build(:product) }
  let(:file_content) do
    "0000000080                                 Raquel  Kuhn00000008770000000003      817.1320210612"
  end
  let(:file) { StringIO.new(file_content) }

  describe '#process_file' do
    it 'processes the file and creates transactions correctly' do
        transaction_gateway = TransactionGateway.new
        transactions = transaction_gateway.process_file(file)

        expect(transactions).to be_an(Array)
        expect(transactions.first['user_id']).to eq(user.id)
        expect(transactions.first['name']).to eq(user.name)
        expect(transactions.first['orders'].first['order_id']).to eq(order.id)
        expect(transactions.first['orders'].first['total']).to eq("817.13")
        expect(transactions.first['orders'].first['products'].first['product_id']).to eq(product.product_id)
        expect(transactions.first['orders'].first['products'].first['value']).to eq("817.13")
    end


    it 'does not process when the file is empty' do
      empty_file = StringIO.new('')
      transaction_gateway = TransactionGateway.new
      transactions = transaction_gateway.process_file(empty_file)

      expect(transactions).to eq([])
    end

    it 'creates transactions correctly when adding a new product to the order' do
      file_content = "0000000080                                 Raquel  Kuhn00000008770000000003      817.1320210612"
      file = StringIO.new(file_content)
      transaction_gateway = TransactionGateway.new
      transactions = transaction_gateway.process_file(file)

      expect(transactions.first['orders'].first['products'].count).to eq(1)
      expect(transactions.first['orders'].first['total']).to eq("817.13")
    end

    it 'creates transactions correctly when adding a new products to the order' do
        file_content =
        "0000000080                                 Raquel  Kuhn00000008770000000003      817.1320210612\n" +
        "0000000080                                 Raquel  Kuhn00000008770000000005      717.1320210612"
        file = StringIO.new(file_content)
        transaction_gateway = TransactionGateway.new
        transactions = transaction_gateway.process_file(file)

        expect(transactions.first['orders'].first['products'].count).to eq(2)
        expect(transactions.first['orders'].first['total']).to eq("1534.26")
      end

    it 'update the order total correctly when there is more than one occurrence same product' do
      file_content =
        "0000000080                                 Raquel  Kuhn00000008770000000003      917.1320210612\n" +
        "0000000080                                 Raquel  Kuhn00000008770000000003      717.1320210612\n" +
        "0000000080                                 Raquel  Kuhn00000008770000000003      817.1320210612"
      file = StringIO.new(file_content)
      transaction_gateway = TransactionGateway.new
      transactions = transaction_gateway.process_file(file)

      expect(transactions.first['orders'].first['total']).to eq("917.13")
    end

    it 'update the order total correctly when there is more than one product' do
        file_content =
          "0000000080                                 Raquel  Kuhn00000008770000000003      917.1320210612\n" +
          "0000000080                                 Raquel  Kuhn00000008770000000004      717.1320210612\n" +
          "0000000080                                 Raquel  Kuhn00000008770000000005      817.1320210612"
        file = StringIO.new(file_content)
        transaction_gateway = TransactionGateway.new
        transactions = transaction_gateway.process_file(file)

        expect(transactions.first['orders'].first['total']).to eq("2451.39")
      end
  end
end
