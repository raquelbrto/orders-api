class Users::ShowUseCase
  def execute(id)
    UserGateway.new.show(id)
  end
end