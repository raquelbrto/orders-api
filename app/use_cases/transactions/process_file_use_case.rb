class Transactions::ProcessFileUseCase
  def execute(file)
    TransactionGateway.new.process_file(file)
  end
end
