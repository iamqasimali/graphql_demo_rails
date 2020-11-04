# README
GraphQL is a query language for APIs. The query language itself is universal and not tied to any frontend or backend technology. This characteristic makes it a great choice for many frameworks or patterns you or your company might follow.


# Basisc Gems for GraphQl
gem ‘graphql’
gem ‘graphiql-rails’ add this one only in development group

GraphQL Gem: the most popular library for building GraphQL applications
GraphiQL: An in-browser IDE for exploring GraphQL, which comes bundled with GraphQL Gem

When you set graphiql-rails only for developement then you have to also define it in routes.rb file
if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "graphql#execute"
end


Add these line to app/assets/config/manifest.js file which used for Graphiql: http://localhost:3000/graphiql 

//= link graphiql/rails/application.css
//= link graphiql/rails/application.js



The Schema Definition Language (SDL):
GraphQL has its own type system that’s used to define the schema of an API. The syntax for writing schemas is called Schema Definition Language (SDL).


After setup firstly you have to crate a type under app/graphql/Types
Like if you have a model then you simply creat it type by entering the following command in console of you app directory
i.e. you have USER model then type 
    rails g graphql:object user
this will generate a new type named as user_type.rb in app/graphql/Types containing all fields of model 

File 'user_type.rb'

module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :email, String, null: true
    field :name, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end

You can also add new filed in your type like 

module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :email, String, null: true
    field :name, String, null: true
    field :posts,[Types::PostType],null: true  // To get the post of the user
    field :post_count, Integer, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    def post_count
      object.posts.size
    end
  end
end

Then you have simple define you queries in query_type.rb file 

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
  end
end

At its simplest, GraphQL is about asking for specific fields on objects. Let's start by looking at a very simple query and the result we get when we run it:





