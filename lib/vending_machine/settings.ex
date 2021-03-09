defmodule VendingMachine.Settings do
  @moduledoc """
  Module that handle the settings functionality
  """

  alias Mix.Shell
  alias VendingMachine.{Display, Loader}

  def display(state) do
    IO.puts("")
    IO.puts("-------------------------------")
    IO.puts(IO.ANSI.format([:bright, "Settings"]))
    IO.puts("-------------------------------")
    IO.puts("#{format("Option")}| #{format("Name")}")
    IO.puts(String.duplicate("-", 15) <> "|" <> String.duplicate("-", 15))

    IO.puts(format("1") <> "|" <> format(" Reload Products"))
    IO.puts(format("2") <> "|" <> format(" Reload Change"))
    IO.puts(format("c") <> "|" <> format(" Cancel"))

    state
  end

  def prompt_for_settings(state) do
    IO.puts("")

    input =
      Shell.IO.prompt("Please, choose a setting option to enter:")
      |> String.trim()

    {input, state}
  end

  def handle_settings({"1", state}) do
    with {:ok, products} <- Loader.products() do
      state =
        state
        |> Map.put(:products, products)

      IO.puts("")
      IO.puts(IO.ANSI.format([:bright, "Product reloaded."]))
      main_menu(state)
    end
  end

  def handle_settings({"2", state}) do
    with {:ok, coins} <- Loader.coins() do
      state =
        state
        |> Map.put(:coins, coins)

      IO.puts("")
      IO.puts(IO.ANSI.format([:bright, "Change reloaded."]))
      main_menu(state)
    end
  end

  def handle_settings({"c", state}) do
    main_menu(state)
  end

  defp main_menu(state), do: Display.main_menu(state)

  defp format(value), do: String.pad_trailing(to_string(value), 15)
end
