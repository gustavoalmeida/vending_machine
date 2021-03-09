defmodule VendingMachine.Products do
  @moduledoc """
  Module that handle functionalities related with products
  """

  alias Mix.Shell
  alias VendingMachine.{Display, CashRegister, Loader}

  def load() do
    Loader.products()
  end

  def display(state) do
    IO.puts("")
    IO.puts("-------------------------------")
    IO.puts(IO.ANSI.format([:bright, "Product menu"]))
    IO.puts("-------------------------------")
    IO.puts("#{format("Id")}| #{format("Name")}| #{format("Price")}| #{format("Stock")}")

    for product <- state.products do
      IO.puts(
        "#{format(product.id)}| #{format(product.name)}| #{format(product.price)}| #{
          format(stock_value(product.stock))
        }"
      )
    end

    IO.puts("#{format("c")}| #{format("Cancel")}")

    state
  end

  def prompt_for_product(state) do
    IO.puts("")

    input =
      Shell.IO.prompt("Please, choose a coin option to insert:")
      |> String.trim()

    {input, state}
  end

  def handle_product({"c", state}) do
    main_menu(state)
  end

  def handle_product({input, state}) do
    state.products
    |> Enum.find(&(Integer.to_string(&1.id) == input))
    |> case do
      nil ->
        IO.puts("Product not found.")

        prompt_for_product(state)
        |> handle_product()

      %{stock: 0} ->
        IO.puts("Product not available.")

        prompt_for_product(state)
        |> handle_product()

      product ->
        state
        |> Map.put(:product, product)
        |> checkout()
    end
  end

  def deliver_product({:yes, state}) do
    IO.puts("")
    IO.puts(IO.ANSI.format([:bright, "Product #{state.product.name} delivered."]))
    IO.puts(IO.ANSI.format([:bright, "Thank you."]))

    state
    |> decrement_stock()
    |> clear_product()
    |> main_menu()
  end

  def deliver_product({:no, state}) do
    state
    |> clear_product()
    |> main_menu()
  end

  def clear_product(state) do
    state
    |> Map.put(:product, nil)
  end

  def decrement_stock(state) do
    state
    |> Map.update!(:products, fn products ->
      products
      |> Enum.map(fn product ->
        if state.product.id == product.id do
          Map.update!(product, :stock, fn stock -> stock - 1 end)
        else
          product
        end
      end)
    end)
  end

  defp format(value), do: String.pad_trailing(to_string(value), 15)
  defp stock_value(0), do: "not available"
  defp stock_value(value), do: value
  defp main_menu(state), do: Display.main_menu(state)
  defp checkout(state), do: CashRegister.checkout(state)
end
