defmodule OincWeb.SchemaTest do
  use OincWeb.ConnCase
  use OincWeb.SubscriptionCase

  alias Oinc.Bank
  alias Oinc.Bank.Projections.{Account, Address, Client}

  setup %{conn: conn} do
    client_params = build(:client_params)
    {:ok, %Client{} = client} = Bank.create_client(client_params)

    {:ok, conn: conn, client: client}
  end

  describe "clients query" do
    test "when a valid id is given, returns the client", %{conn: conn} do
      cpf = "22222222222"
      client_params = build(:client_params, %{"cpf" => cpf})
      {:ok, %Client{} = client} = Bank.create_client(client_params)

      query = """
      {
        client(id: "#{client.id}") {
          name
        }
      }
      """

      expected_response = %{"data" => %{"client" => %{"name" => "Vinicius Moreira"}}}

      response =
        conn
        |> post("/api/graphql", %{query: query})
        |> json_response(:ok)

      assert response == expected_response
    end

    test "when a valid id is given, returns the client with address", %{conn: conn} do
      cpf = "22222222222"
      client_params = build(:client_params, %{"cpf" => cpf})
      {:ok, %Client{} = client} = Bank.create_client(client_params)

      create_address = build(:address_params, %{"client_id" => client.id})
      Bank.create_address(create_address)

      query = """
      {
        client(id: "#{client.id}") {
          name,
          address{
            city,
            state
          }
        }
      }
      """

      expected_response = %{
        "data" => %{
          "client" => %{
            "name" => "Vinicius Moreira",
            "address" => %{"city" => "Belo Horizonte", "state" => "MG"}
          }
        }
      }

      response =
        conn
        |> post("/api/graphql", %{query: query})
        |> json_response(:ok)

      assert response == expected_response
    end

    test "when the client does not exist, returns an error", %{conn: conn} do
      query = """
      {
        client(id: "54ce2b27-9891-45ea-ace7-d3dcf7edf2fb") {
          name
        }
      }
      """

      expected_response = %{
        "errors" => [
          %{
            "locations" => [%{"column" => 3, "line" => 2}],
            "message" => "not_found",
            "path" => ["client"]
          }
        ],
        "data" => %{"client" => nil}
      }

      response =
        conn
        |> post("/api/graphql", %{query: query})
        |> json_response(:ok)

      assert response == expected_response
    end

    test "when a invalid UUID, returns an error", %{conn: conn} do
      query = """
      {
        client(id: "1") {
          name
        }
      }
      """

      expected_response = %{
        "errors" => [
          %{
            "locations" => [%{"column" => 10, "line" => 2}],
            "message" => "Argument \"id\" has invalid value \"1\"."
          }
        ]
      }

      response =
        conn
        |> post("/api/graphql", %{query: query})
        |> json_response(:ok)

      assert response == expected_response
    end
  end

  describe "clients mutation" do
    test "when all params are valid, creates the client", %{conn: conn} do
      mutation = """
        mutation {
          createClient(input: {
            name: "teste",
            cpf: "111111111111"
          }) {
            id,
            name,
            cpf
          }
        }
      """

      response =
        conn
        |> post("/api/graphql", %{query: mutation})
        |> json_response(:ok)

      assert %{
               "data" => %{
                 "createClient" => %{
                   "name" => "teste",
                   "cpf" => "111111111111"
                 }
               }
             } = response
    end

    test "when an params are invalid, return an error", %{conn: conn} do
      mutation = """
        mutation {
          createClient(input: {
            name: ""
          }) {
            id,
            name
          }
        }
      """

      response =
        conn
        |> post("/api/graphql", %{query: mutation})
        |> json_response(:ok)

      assert %{
               "errors" => [
                 %{
                   "locations" => [%{"column" => 18, "line" => 2}],
                   "message" =>
                     "Argument \"input\" has invalid value {name: \"\"}.\nIn field \"cpf\": Expected type \"String!\", found null."
                 }
               ]
             } == response
    end
  end

  describe "address query" do
    test "when a valid id is given, returns the address", %{conn: conn, client: client} do
      create_address = build(:address_params, %{"client_id" => client.id})
      {:ok, %Address{} = address} = Bank.create_address(create_address)

      query = """
      {
        address(id: "#{address.id}") {
          city,
          state,
          client {
            name,
            cpf
          }
        }
      }
      """

      expected_response = %{
        "data" => %{
          "address" => %{
            "city" => "Belo Horizonte",
            "state" => "MG",
            "client" => %{"cpf" => "11111111111", "name" => "Vinicius Moreira"}
          }
        }
      }

      response =
        conn
        |> post("/api/graphql", %{query: query})
        |> json_response(:ok)

      assert response == expected_response
    end

    test "when the address does not exist, returns an error", %{conn: conn} do
      query = """
      {
        address(id: "54ce2b27-9891-45ea-ace7-d3dcf7edf2fb") {
          city
        }
      }
      """

      expected_response = %{
        "errors" => [
          %{
            "locations" => [%{"column" => 3, "line" => 2}],
            "message" => "not_found",
            "path" => ["address"]
          }
        ],
        "data" => %{"address" => nil}
      }

      response =
        conn
        |> post("/api/graphql", %{query: query})
        |> json_response(:ok)

      assert response == expected_response
    end

    test "when a invalid UUID, returns an error", %{conn: conn} do
      query = """
      {
        address(id: "1") {
          city
        }
      }
      """

      expected_response = %{
        "errors" => [
          %{
            "locations" => [%{"column" => 11, "line" => 2}],
            "message" => "Argument \"id\" has invalid value \"1\"."
          }
        ]
      }

      response =
        conn
        |> post("/api/graphql", %{query: query})
        |> json_response(:ok)

      assert response == expected_response
    end
  end

  describe "address mutation" do
    test "when all params are valid, creates the address", %{conn: conn, client: client} do
      mutation = """
        mutation {
          createAddress(input: {
            state: "state teste",
            city: "city test",
            clientId: "#{client.id}"
          }) {
            id,
            city,
            state
          }
        }
      """

      response =
        conn
        |> post("/api/graphql", %{query: mutation})
        |> json_response(:ok)

      assert %{
               "data" => %{
                 "createAddress" => %{
                   "state" => "state teste",
                   "city" => "city test"
                 }
               }
             } = response
    end

    test "when an params are invalid, return an error", %{conn: conn} do
      mutation = """
        mutation {
          createAddress(input: {
            city: ""
          }) {
            id,
            city
          }
        }
      """

      response =
        conn
        |> post("/api/graphql", %{query: mutation})
        |> json_response(:ok)

      assert %{
               "errors" => [
                 %{
                   "locations" => [%{"column" => 19, "line" => 2}],
                   "message" =>
                     "Argument \"input\" has invalid value {city: \"\"}.\nIn field \"state\": Expected type \"String!\", found null.\nIn field \"clientId\": Expected type \"UUID4!\", found null."
                 }
               ]
             } == response
    end
  end

  describe "account query" do
    test "when a valid id is given, returns the account", %{conn: conn, client: client} do
      open_account = build(:open_account_params, %{"client_id" => client.id})
      assert {:ok, %Account{} = account} = Bank.open_account(open_account)

      query = """
      {
        account(id: "#{account.id}") {
          current_balance,
          status,
          client {
            name,
            cpf
          }
        }
      }
      """

      expected_response = %{
        "data" => %{
          "account" => %{
            "client" => %{"cpf" => "11111111111", "name" => "Vinicius Moreira"},
            "current_balance" => 100,
            "status" => "open"
          }
        }
      }

      response =
        conn
        |> post("/api/graphql", %{query: query})
        |> json_response(:ok)

      assert response == expected_response
    end

    test "when the account does not exist, returns an error", %{conn: conn} do
      query = """
      {
        account(id: "54ce2b27-9891-45ea-ace7-d3dcf7edf2fb") {
          current_balance
        }
      }
      """

      expected_response = %{
        "errors" => [
          %{
            "locations" => [%{"column" => 3, "line" => 2}],
            "message" => "not_found",
            "path" => ["account"]
          }
        ],
        "data" => %{"account" => nil}
      }

      response =
        conn
        |> post("/api/graphql", %{query: query})
        |> json_response(:ok)

      assert response == expected_response
    end

    test "when a invalid UUID, returns an error", %{conn: conn} do
      query = """
      {
        account(id: "1") {
          current_balance
        }
      }
      """

      expected_response = %{
        "errors" => [
          %{
            "locations" => [%{"column" => 11, "line" => 2}],
            "message" => "Argument \"id\" has invalid value \"1\"."
          }
        ]
      }

      response =
        conn
        |> post("/api/graphql", %{query: query})
        |> json_response(:ok)

      assert response == expected_response
    end
  end

  describe "open account mutation" do
    test "when all params are valid, open the account", %{conn: conn, client: client} do
      mutation = """
        mutation {
          openAccount(input: {
            initialBalance: 200,
            clientId: "#{client.id}"
          }) {
            id,
            current_balance,
            status,
            client {
              name,
              cpf
            }
          }
        }
      """

      response =
        conn
        |> post("/api/graphql", %{query: mutation})
        |> json_response(:ok)

      assert %{
               "data" => %{
                 "openAccount" => %{
                   "client" => %{"cpf" => "11111111111", "name" => "Vinicius Moreira"},
                   "current_balance" => 200,
                   "status" => "open"
                 }
               }
             } = response
    end

    test "when an params are invalid, return an error", %{conn: conn} do
      mutation = """
        mutation {
          openAccount(input: {
            initialBalance: nil
          }) {
            initialBalance,
            status
          }
        }
      """

      response =
        conn
        |> post("/api/graphql", %{query: mutation})
        |> json_response(:ok)

      assert %{
               "errors" => [
                 %{
                   "locations" => [%{"column" => 7, "line" => 5}],
                   "message" =>
                     "Cannot query field \"initialBalance\" on type \"Account\". Did you mean \"currentBalance\"?"
                 },
                 %{
                   "locations" => [%{"column" => 17, "line" => 2}],
                   "message" =>
                     "Argument \"input\" has invalid value {initialBalance: nil}.\nIn field \"clientId\": Expected type \"UUID4!\", found null.\nIn field \"initialBalance\": Expected type \"Int!\", found nil."
                 }
               ]
             } == response
    end
  end

  describe "close account mutation" do
    setup %{client: client} do
      open_account = build(:open_account_params, %{"client_id" => client.id})
      {:ok, %Account{} = account} = Bank.open_account(open_account)

      {:ok, account: account}
    end

    test "when all params are valid, open the account", %{conn: conn, account: account} do
      mutation = """
        mutation {
          closeAccount(input: {
            id: "#{account.id}"
          }) {
            id,
            status
          }
        }
      """

      response =
        conn
        |> post("/api/graphql", %{query: mutation})
        |> json_response(:ok)

      assert %{
               "data" => %{
                 "closeAccount" => %{
                   "status" => "closed"
                 }
               }
             } = response
    end

    test "when an params are invalid, return an error", %{conn: conn} do
      mutation = """
        mutation {
          closeAccount(input: {
            id: nil
          }) {
            id,
            status
          }
        }
      """

      response =
        conn
        |> post("/api/graphql", %{query: mutation})
        |> json_response(:ok)

      assert %{
               "errors" => [
                 %{
                   "locations" => [%{"column" => 18, "line" => 2}],
                   "message" =>
                     "Argument \"input\" has invalid value {id: nil}.\nIn field \"id\": Expected type \"UUID4!\", found nil."
                 }
               ]
             } == response
    end
  end

  describe "deposit account mutation" do
    setup %{client: client} do
      open_account = build(:open_account_params, %{"client_id" => client.id})
      {:ok, %Account{} = account} = Bank.open_account(open_account)

      {:ok, account: account}
    end

    test "when all params are valid, open the account", %{conn: conn, account: account} do
      amount = 100
      new_current_balance = account.current_balance + amount

      mutation = """
        mutation {
          depositAccount(input: {
            id: "#{account.id}",
            amount: 100
          }) {
            id,
            current_balance,
            status,
            client {
              name,
              cpf
            }
          }
        }
      """

      response =
        conn
        |> post("/api/graphql", %{query: mutation})
        |> json_response(:ok)

      assert %{
               "data" => %{
                 "depositAccount" => %{
                   "client" => %{"cpf" => "11111111111", "name" => "Vinicius Moreira"},
                   "current_balance" => current_balance,
                   "status" => "open"
                 }
               }
             } = response

      assert current_balance == new_current_balance
    end

    test "when an params are invalid, return an error", %{conn: conn} do
      mutation = """
        mutation {
          depositAccount(input: {
            id: nil
          }) {
            id,
            status
          }
        }
      """

      response =
        conn
        |> post("/api/graphql", %{query: mutation})
        |> json_response(:ok)

      assert %{
               "errors" => [
                 %{
                   "locations" => [%{"column" => 20, "line" => 2}],
                   "message" =>
                     "Argument \"input\" has invalid value {id: nil}.\nIn field \"amount\": Expected type \"Int!\", found null.\nIn field \"id\": Expected type \"UUID4!\", found nil."
                 }
               ]
             } == response
    end
  end

  describe "withdrawn account mutation" do
    setup %{client: client} do
      open_account = build(:open_account_params, %{"client_id" => client.id})
      {:ok, %Account{} = account} = Bank.open_account(open_account)

      {:ok, account: account}
    end

    test "when all params are valid, open the account", %{conn: conn, account: account} do
      amount = 100
      new_current_balance = account.current_balance - amount

      mutation = """
        mutation {
          withdrawnAccount(input: {
            id: "#{account.id}",
            amount: 100
          }) {
            id,
            current_balance,
            status,
            client {
              name,
              cpf
            }
          }
        }
      """

      response =
        conn
        |> post("/api/graphql", %{query: mutation})
        |> json_response(:ok)

      assert %{
               "data" => %{
                 "withdrawnAccount" => %{
                   "client" => %{"cpf" => "11111111111", "name" => "Vinicius Moreira"},
                   "current_balance" => current_balance,
                   "status" => "open"
                 }
               }
             } = response

      assert current_balance == new_current_balance
    end

    test "when an params are invalid, return an error", %{conn: conn} do
      mutation = """
        mutation {
          withdrawnAccount(input: {
            id: nil
          }) {
            id,
            status
          }
        }
      """

      response =
        conn
        |> post("/api/graphql", %{query: mutation})
        |> json_response(:ok)

      assert %{
               "errors" => [
                 %{
                   "locations" => [%{"column" => 22, "line" => 2}],
                   "message" =>
                     "Argument \"input\" has invalid value {id: nil}.\nIn field \"amount\": Expected type \"Int!\", found null.\nIn field \"id\": Expected type \"UUID4!\", found nil."
                 }
               ]
             } == response
    end
  end

  # describe "subscription" do
  #   test "client subscription", %{socket: socket} do
  #     mutation = """
  #       mutation {
  #         createClient(input: {
  #           name: "teste",
  #           cpf: "11111111111"
  #         }) {
  #           name
  #         }
  #       }
  #     """

  #     subscription = """
  #       subscription {
  #         newClient {
  #           name
  #         }
  #       }
  #     """

  #     # setup subscription
  #     socket_ref = push_doc(socket, subscription)
  #     assert_reply socket_ref, :ok, %{subscriptionId: subscription_id}

  #     # setup mutation
  #     socket_ref = push_doc(socket, mutation)
  #     assert_reply socket_ref, :ok, mutation_response

  #     expected_mutation_response = %{
  #       data: %{
  #         "createClient" => %{"name" => "teste"}
  #       }
  #     }

  #     expected_subscription_response = %{
  #       result: %{data: %{"newClient" => %{"name" => "teste"}}},
  #       subscriptionId: subscription_id
  #     }

  #     assert mutation_response == expected_mutation_response

  #     assert_push "subscription:data", subscription_responde
  #     assert subscription_responde == expected_subscription_response
  #   end
  # end
end
