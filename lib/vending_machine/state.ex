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

  def track(state) do
    IO.puts("")
    IO.puts(IO.ANSI.format([:bright, "Machine State:"]))
    IO.puts("")
    IO.puts("Coins:")

    for c <- state.coins do
      total = Money.multiply(c.value, c.count)
      IO.puts("#{c.name}, count: #{c.count}, total:#{total}")
    end

    total =
      state.coins
      |> Enum.reduce(Money.new(0), fn c, acc ->
        Money.add(acc, Money.multiply(c.value, c.count))
      end)

    IO.puts("Total: #{total}")
    IO.puts("")
    IO.puts("Products:")

    for p <- state.products do
      IO.puts("#{p.name}, stock: #{p.stock}")
    end

    IO.puts("")
  end
end
