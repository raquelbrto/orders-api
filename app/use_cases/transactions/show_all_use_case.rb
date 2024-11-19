class Transactions::ShowAllUseCase
  def execute
    TransactionGateway.new.show_all
  end
end