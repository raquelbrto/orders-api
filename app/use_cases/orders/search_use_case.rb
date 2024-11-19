class Orders::SearchUseCase
  def execute(start_date, end_date)
    OrderGateway.new.search(start_date, end_date)
  end
end
