# README
GraphQL is a query language for APIs. The query language itself is universal and not tied to any frontend or backend technology. This characteristic makes it a great choice for many frameworks or patterns you or your company might follow.


# Basics of GraphQL

    gem ‘graphql’
    gem ‘graphiql-rails’ #add this one only in development group

#### GraphQL Gem: 
Most popular library for building applications with GraphQL.
#### GraphiQL: 
A browser IDE for exploring GraphQL, which comes bundled with GraphQL Gem.

> When you set graphiql-rails only for developement then you have to also define it in **routes.rb file**

        if Rails.env.development?
            mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "graphql#execute"
        end


> Add these line to **app/assets/config/manifest.js** file which used for Graphiql: http://localhost:3000/graphiql 

    //= link graphiql/rails/application.css
    //= link graphiql/rails/application.js



## The Schema Definition Language (SDL):
GraphQL has its own type system that’s used to define the schema of an API. The syntax for writing schemas is called Schema Definition Language (SDL).


After setup firstly you have to crate a type under **app/graphql/Types**
Like if you have a model then you simply creat it type by entering the following command in console of you app directory
i.e. you have USER model then type 
        > rails g graphql:object user
this will generate a new type named as **user_type.rb** in **app/graphql/Types** containing all fields of model 

**File 'user_type.rb'**

    module Types
      class UserType < Types::BaseObject
        field :id, ID, null: false
        field :email, String, null: true
        field :name, String, null: true
        field :created_at, GraphQL::Types::ISO8601DateTime, null: false
        field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
      end
    end

> You can also add new filed in your type like 

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

> Then you have simple define you queries in **query_type.rb** file 

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

**Query:**

    {
      users {
        id
        email
        name
      }
    }

**Result:**

    {
      "data": {
        "users": [
          {
            "id": "1",
            "email": "lizette_yundt@cruickshank-sanford.info",
            "name": "Stanley Lockman"
          },
          {
            "id": "2",
            "email": "preston@brown-shields.org",
            "name": "Renato Schultz"
          },
          {
            "id": "3",
            "email": "cory@mayert.io",
            "name": "Myra Gaylord"
          },
          {
            "id": "4",
            "email": "dylan@metz-hammes.org",
            "name": "Barbra Windler"
          },
          {
            "id": "5",
            "email": "ciara.cummings@kuphal-zboncak.io",
            "name": "Cameron Bayer"
          }
        ]
      }
    }


**Query:**

    {
      user(id: 2) {
        id
        email
        postCount
      }
    }

**Result:**

    {
      "data": {
        "user": {
          "id": "2",
          "email": "preston@brown-shields.org",
          "postCount": 5
        }
      }
    }

**Query:**

    {
      user(id: 2) {
        id
        email
        postCount
        posts {
          id
          title
          body
        }
      }
    }

**Result:**

    {
      "data": {
        "user": {
          "id": "2",
          "email": "preston@brown-shields.org",
          "postCount": 5,
          "posts": [
            {
              "id": "6",
              "title": "Beatae vel maiores.",
              "body": "Odio praesentium soluta. Qui veritatis ut. Nisi veritatis consequatur. Unde enim numquam. Corporis nemo velit."
            },
            {
              "id": "7",
              "title": "Ab assumenda omnis.",
              "body": "At eaque harum. Rerum voluptas perferendis. In sunt inventore. Voluptatum similique repudiandae. Qui quod doloribus."
            },
            {
              "id": "8",
              "title": "Rerum at occaecati.",
              "body": "Debitis iure tempora. Sed voluptatem aut. Animi sed numquam. Quasi culpa sint. Sed eos asperiores."
            },
            {
              "id": "9",
              "title": "Assumenda repudiandae tempore.",
              "body": "Omnis consequatur omnis. Velit et recusandae. Non quis provident. Animi consequatur quas. Qui rem quae."
            },
            {
              "id": "10",
              "title": "Consequatur temporibus praesentium.",
              "body": "Deserunt rerum hic. In aut nam. Quia ab exercitationem. Est excepturi et. Odio molestiae blanditiis."
            }
          ]
        }
      }
    }
    
    
## Mutations

Most discussions of GraphQL focus on data fetching, but any complete data platform needs a way to modify server-side data as well.

In REST, any request might end up causing some side-effects on the server, but by convention it's suggested that one doesn't use GET requests to modify data. GraphQL is similar - technically any query could be implemented to cause a data write. However, it's useful to establish a convention that any operations that cause writes should be sent explicitly via a mutation.

Just like in queries, if the mutation field returns an object type, you can ask for nested fields. This can be useful for fetching the new state of an object after an update. Let's look at a simple example mutation:

> I have crate a mutation for new user file **create_user.rb** under mutatiions directory

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
    
  > To call mutation firstly we have to define it in **mutation_type.rb** under **graphql/Types directory**
   like:

    module Types
      class MutationType < Types::BaseObject
        field :create_user, mutation: Mutations::CreateUser
        field :register_user, mutation: Mutations::RegisterUser
      end
    end
 > Here, I have declare two mutation for **create_user** and register_user. Now just simply need to call it 

**Query:**

    mutation {
      createUser(input: {name: "Qasim Ali Zahid", email: "iamqasimali@gmail.com"}) {
        user {
          id
          name
          email
        }
        error
      }
    }

**Result:**

    {
      "data": {
        "createUser": {
          "user": {
            "id": "6",
            "name": "Qasim Ali Zahid",
            "email": "iamqasimali@gmail.com"
          },
          "error": []
        }
      }
    }
