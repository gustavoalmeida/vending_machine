defmodule VendingMachine.CashRegister do
  @moduledoc """
  Module that handle functionalities related with the cash register
  """

  alias VendingMachine.{Display, Balance, CashRegister, Products}

  def checkout(state) do
    state
    |> Map.update!(:balance, fn balance ->
      Balance.debit(balance, state.product.price)
    end)
    |> handle_balance()
    |> has_enough_balance()
    |> calculate_change()
    |> Products.deliver_product()
  end

  def calculate_change(state) do
    change = CashRegister.change(state.coins, state.balance)

    change
    |> CashRegister.validate_change(state.coins)
    |> if do
      state
      |> Map.put(:change, change)
      |> return_change()
    else
      change_fail(state)
    end
  end

  def ask_for_coin(state) do
    IO.puts("")
    IO.puts("Please insert coin.")

    state
    |> coins()
    |> handle_balance()
    |> has_enough_balance()
  end

  def has_enough_balance({:no, state}) do
    ask_for_coin(state)
  end

  def has_enough_balance({:yes, state}), do: state

  def handle_balance(state) do
    IO.puts("")
    IO.puts("Balance: #{state.balance}")

    state
    |> Map.get(:balance)
    |> Balance.is_enough()
    |> if do
      {:yes, state}
    else
      {:no, state}
    end
  end

  def change_fail(state) do
    IO.puts(
      IO.ANSI.format([:bright, "Ops. Sorry, there is not enough coin to deliver your change."])
    )

    state = return_coins(state)
    {:no, state}
  end

  def remove(coin, coins) do
    Enum.map(coins, fn c ->
      if coin.id == c.id do
        Map.put(c, :count, c.count - 1)
      else
        c
      end
    end)
  end

  def add(coin, coins) do
    Enum.map(coins, fn c ->
      if coin.id == c.id do
        Map.put(c, :count, c.count + 1)
      else
        c
      end
    end)
  end

  def change(coins, balance) do
    acc = %{change: [], amount: balance.amount}

    coins
    |> Enum.sort_by(& &1.value.amount, :desc)
    |> Enum.reduce(acc, fn coin, acc ->
      if acc.amount >= coin.value.amount do
        acc
        |> Map.put(
          :change,
          acc.change ++ List.duplicate(coin, div(acc.amount, coin.value.amount))
        )
        |> Map.put(:amount, rem(acc.amount, coin.value.amount))
      else
        acc
      end
    end)
    |> Map.get(:change)
    |> List.flatten()
  end

  def validate_change([], _coins), do: true

  def validate_change(change, coins) do
    [coin | change] = change

    if has_coin?(coin, coins) do
      coins = remove(coin, coins)
      validate_change(change, coins)
    else
      false
    end
  end

  @spec has_coin?(any, any) :: any
  def has_coin?(coin, coins) do
    Enum.find(coins, &(&1.id == coin.id and &1.count > 0))
    |> case do
      nil -> false
      _ -> true
    end
  end

  def return_coins(state) do
    IO.puts("")
    IO.puts(IO.ANSI.format([:bright, "Returning your coins:"]))

    total =
      state.added_coins
      |> Enum.reduce(Money.new(0), fn coin, acc ->
        IO.puts("#{coin.name}")
        Money.add(acc, coin.value)
      end)

    state =
      state
      |> Map.update!(:coins, fn coins ->
        to_return =
          state.added_coins
          |> Enum.reduce(%{}, fn coin, acc -> Map.update(acc, coin.id, 1, &(&1 + 1)) end)

        coins
        |> Enum.map(fn coin ->
          to_return
          |> Map.get(coin.id)
          |> if do
            Map.update!(coin, :count, fn count -> count - 1 end)
          else
            coin
          end
        end)
      end)
      |> Map.put(:added_coins, [])
      |> reset_balance()

    IO.puts(IO.ANSI.format([:bright, "Total returned: #{total}"]))
    IO.puts(IO.ANSI.format([:bright, "The operation has been canceled."]))
    state
  end

  defp return_change(result), do: Display.return_change(result)
  defp coins(result), do: Display.coins(result)

  defp reset_balance(state) do
    Map.put(state, :balance, Balance.new())
  end
end
