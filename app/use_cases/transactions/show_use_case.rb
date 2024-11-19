class Transactions::ShowUseCase
  def execute(id)
    TransactionGateway.new.show(id)
  end
end