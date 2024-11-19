class Orders::ShowUseCase
  def execute(id)
    OrderGateway.new.show(id)
  end
end