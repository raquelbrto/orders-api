class Orders::ShowAllUseCase
  def execute
    OrderGateway.new.show_all
  end
end