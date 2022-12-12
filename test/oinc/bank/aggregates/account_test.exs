defmodule Oinc.Bank.Aggregates.AccountTest do
  use Oinc.AggregateCase, aggregate: Oinc.Bank.Aggregates.Account

  alias Oinc.Bank.Commands.DepositAccount
  alias Oinc.Bank.Events.DepositedAccount

  describe "open account" do
    @tag :unit
    test "should succeed when valid" do
      account_id = Ecto.UUID.generate()
      client_id = Ecto.UUID.generate()

      assert_events(
        build(:open_account, account_id: account_id, client_id: client_id),
        [
          build(:account_opened, account_id: account_id, client_id: client_id)
        ]
      )
    end
  end

  describe "deposit account" do
    @tag :unit
    test "should succeed when valid" do
      account_id = Ecto.UUID.generate()
      account = build(:account_opened, account_id: account_id)
      amount = 100
      initial_balance = account.initial_balance
      new_amount = initial_balance + amount

      assert_events(
        account,
        %DepositAccount{account_id: account_id, deposit_amount: 100},
        [
          %DepositedAccount{
            account_id: account_id,
            new_current_balance: new_amount
          }
        ]
      )
    end
  end
end
