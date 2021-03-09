defmodule VendingMachine.State do
  @moduledoc """
  Module that handle the state of the machine
  """

  alias VendingMachine.Balance
  alias VendingMachine.Products
  alias VendingMachine.Coins

  def initial_state() do
    with {:ok, products} <- Products.load(),
         {:ok, coins} <- Coins.load(),
         {:ok, balance} <- Balance.new() do
      {:ok,
       Map.new([
         {:products, products},
         {:coins, coins},
         {:balance, balance},
         {:added_coins, []}
       ])}
    end
  end
end
