defmodule VendingMachine.Display do
  @moduledoc """
  Module that handle functionalities related display interactions and main menu
  """

  alias Mix.Shell

  alias VendingMachine.Balance

  alias VendingMachine.Products
  alias VendingMachine.Coins
  alias VendingMachine.Settings

  def welcome do
    IO.puts("-------------------------------")
    IO.puts(IO.ANSI.format([:bright, "Welcome to the Vending Machine!"]))
    IO.puts("-------------------------------")
    IO.puts("")
  end

  def products(state) do
    Products.display(state)
    |> Products.prompt_for_product()
    |> Products.handle_product()
  end

  def coins(state) do
    Coins.display(state)
    |> Coins.prompt_for_coin()
    |> Coins.handle_coin()
  end

  def settings(state) do
    Settings.display(state)
    |> Settings.prompt_for_settings()
    |> Settings.handle_settings()
  end

  def main_menu(state) do
    show_main_menu()

    state
    |> prompt_for_main_menu()
    |> handle_main_menu()
  end

  @spec show_main_menu() :: :ok
  def show_main_menu() do
    IO.puts("")
    IO.puts("-------------------------------")
    IO.puts(IO.ANSI.format([:bright, "Main menu"]))
    IO.puts("-------------------------------")

    IO.puts("#{format("Option")}| #{format("Name")}")
    IO.puts(String.duplicate("-", 15) <> "|" <> String.duplicate("-", 15))

    IO.puts(format("1") <> "|" <> format(" Buy Product"))
    IO.puts(format("2") <> "|" <> format(" Settings"))
    IO.puts(format("c") <> "|" <> format(" Cancel"))
  end

  def handle_main_menu({"1", state}) do
    products(state)
  end

  def handle_main_menu({"2", state}) do
    settings(state)
  end

  def handle_main_menu({c, _state}) when c in ["c", "C"] do
    IO.puts("")
    IO.puts(IO.ANSI.format([:bright, "Operation has been canceled."]))
    IO.puts("")
  end

  def handle_main_menu({input, state}) do
    IO.puts("")
    IO.puts(IO.ANSI.format([:bright, "Option \"#{input}\" is not valid. Try again..."]))
    main_menu(state)
  end

  def prompt_for_main_menu(state) do
    IO.puts("")

    input =
      Shell.IO.prompt("Please, choose an option from the main menu:")
      |> String.trim()

    {input, state}
  end

  @spec prompt_for_option(any) :: {binary, any}
  def prompt_for_option(state) do
    IO.puts("")

    input =
      Shell.IO.prompt("Please, chose and option:")
      |> String.trim()

    {input, state}
  end

  defp format(value), do: String.pad_trailing(to_string(value), 15)

  def change([]), do: nil

  def return_change(%{change: []} = state) do
    state =
      state
      |> reset_balance()

    {:yes, state}
  end

  def return_change(%{change: change} = state) do
    IO.puts(IO.ANSI.format([:bright, "Returning change:"]))

    total =
      change
      |> Enum.reduce(Money.new(0), fn coin, acc ->
        IO.puts("#{coin.name}")
        Money.add(acc, coin.value)
      end)

    state =
      state
      |> reset_balance()

    IO.puts(IO.ANSI.format([:bright, "Total change returned: #{total}"]))
    {:yes, state}
  end

  def reset_balance(state) do
    Map.put(state, :balance, Balance.new())
  end
end
