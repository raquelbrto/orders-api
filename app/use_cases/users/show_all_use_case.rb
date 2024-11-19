class Users::ShowAllUseCase
  def execute
    UserGateway.new.show_all
  end
end
