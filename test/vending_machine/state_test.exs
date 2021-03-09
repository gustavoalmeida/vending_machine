defmodule VendingMachine.StateTest do
  use ExUnit.Case
  alias VendingMachine.State

  describe "initial_state/2" do
    test "initializing machine state" do
      initial_state = State.initial_state()

      assert {:ok,
              %{
                added_coins: [],
                balance: %Money{amount: 0, currency: :GBP},
                coins: [
                  %{count: 1, id: 1, name: "1p", value: %Money{amount: 1, currency: :GBP}},
                  %{count: 3, id: 2, name: "2p", value: %Money{amount: 2, currency: :GBP}},
                  %{count: 2, id: 3, name: "5p", value: %Money{amount: 5, currency: :GBP}},
                  %{count: 5, id: 4, name: "10p", value: %Money{amount: 10, currency: :GBP}},
                  %{count: 2, id: 5, name: "20p", value: %Money{amount: 20, currency: :GBP}},
                  %{count: 2, id: 6, name: "50p", value: %Money{amount: 50, currency: :GBP}},
                  %{count: 9, id: 7, name: "£1", value: %Money{amount: 100, currency: :GBP}},
                  %{count: 10, id: 8, name: "£2", value: %Money{amount: 200, currency: :GBP}}
                ],
                products: [
                  %{id: 1, name: "Coke", price: %Money{amount: 115, currency: :GBP}, stock: 1},
                  %{id: 2, name: "Snack", price: %Money{amount: 225, currency: :GBP}, stock: 1}
                ]
              }} = initial_state
    end
  end
end
