defmodule VendingMachine.Loader do
  @moduledoc """
  Module that handle functionalities related with product and coin loading
  """
  def products() do
    Application.get_env(:vending_machine, :products_path)
    |> load(:product)
  end

  def coins() do
    Application.get_env(:vending_machine, :coins_path)
    |> load(:coin)
  end

  def load(csv_path, type) do
    items =
      csv_path
      |> Path.expand(__DIR__)
      |> File.stream!()
      |> CSV.decode(headers: true)
      |> Enum.map(fn row ->
        format(row, type)
      end)

    {:ok, items}
  end

  defp format({:ok, map}, :product) do
    %{
      id: String.to_integer(map["id"]),
      name: map["name"],
      price: Money.parse!(map["price"]),
      stock: String.to_integer(map["stock"])
    }
  end

  defp format({:ok, map}, :coin) do
    %{
      id: String.to_integer(map["id"]),
      name: map["name"],
      value: Money.parse!(map["value"]),
      count: String.to_integer(map["count"])
    }
  end
end
