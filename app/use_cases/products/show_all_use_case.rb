class Products::ShowAllUseCase
  def execute
    ProductGateway.new.show_all
  end
end
