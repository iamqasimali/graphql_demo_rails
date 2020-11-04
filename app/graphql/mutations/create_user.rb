class Mutations::CreateUser < Mutations::BaseMutation
  argument :name, String, required: true
  argument :email, String, required: true

  field :user, Types::UserType,null: false
  field :error, [String], null: false

  def resolve(name:, email:)
    user = User.new(name: name,email: email)
    if user.save!
      {user: user, error: []}
    else
      {user: nil, error: user.errors.full_messages }
    end
  end
end