module Types
  class MutationType < Types::BaseObject
    field :create_user, mutation: Mutations::CreateUser
    # field :register_user, mutation: Mutations::RegisterUser
  end
end
