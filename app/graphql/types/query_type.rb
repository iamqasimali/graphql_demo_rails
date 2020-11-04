module Types
  class QueryType < Types::BaseObject
    # Users
    field :users, [Types::UserType], null: false
    def users
      User.all
    end
    # User
    field :user, Types::UserType, null: false do
      argument :id, ID, required: true
    end
    def user(id:)
      User.find(id)
    end
    #Post
    field :posts, [Types::PostType], null: false
    def posts
      Post.all
    end
  end
end
