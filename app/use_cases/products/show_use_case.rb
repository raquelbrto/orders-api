class Products::ShowUseCase
  def execute(id)
    ProductGateway.new.show(id)
  end
end