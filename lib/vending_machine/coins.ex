defmodule VendingMachine.Coins do
  @moduledoc """
  Module that handle functionalities related with conis
  """

  alias Mix.Shell
  alias VendingMachine.Balance
  alias VendingMachine.Loader

  def load() do
    Loader.coins()
  end

  def display(state) do
    IO.puts("")
    IO.puts("-------------------------------")
    IO.puts(IO.ANSI.format([:bright, "Coin menu"]))
    IO.puts("-------------------------------")
    IO.puts("#{format("Id")}| #{format("Name")}| #{format("Value")}| #{format("Count")}")

    for coin <- state.coins do
      IO.puts(
        "#{format(coin.id)}| #{format(coin.name)}| #{format(coin.value)}| #{format(coin.count)}"
      )
    end

    state
  end

  def prompt_for_coin(state) do
    IO.puts("")

    input =
      Shell.IO.prompt("Please, choose a coin option to insert:")
      |> String.trim()

    {input, state}
  end

  def handle_coin({input, state}) do
    state.coins
    |> Enum.find(&(Integer.to_string(&1.id) == input))
    |> case do
      nil ->
        IO.puts("Coin not found.")

        prompt_for_coin(state)
        |> handle_coin()

      coin ->
        state
        |> Map.update!(:coins, fn coins ->
          coins
          |> Enum.map(fn c ->
            if c.id == coin.id do
              Map.update!(c, :count, fn count -> count + 1 end)
            else
              c
            end
          end)
        end)
        |> Map.update!(:balance, fn balance ->
          Balance.credit(balance, coin.value)
        end)
        |> Map.update!(:added_coins, fn added_coins ->
          added_coins ++ [coin]
        end)
    end
  end

  defp format(value), do: String.pad_trailing(to_string(value), 15)
end
