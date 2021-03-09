defmodule VendingMachine.ProductsTest do
  use ExUnit.Case

  alias VendingMachine.State
  alias VendingMachine.Display
  alias VendingMachine.Products
  alias VendingMachine.CashRegister
  alias Mix.Shell.IO, as: ShellIO

  import ExUnit.CaptureIO

  use Mimic

  describe "display/1" do
    test "show products menu" do
      {:ok, state} = State.initial_state()
      products = capture_io(fn -> Products.display(state) end)
      expected = File.read!(Path.expand("../data/products/products_menu.txt", __DIR__))
      assert products == expected
    end
  end

  describe "prompt_for_product/1" do
    test "ask for products menu option" do
      message = capture_io([input: "c"], fn -> Products.prompt_for_product(%{}) end)
      expected = File.read!(Path.expand("../data/products/products_prompt.txt", __DIR__))
      assert message == expected
    end

    test "handle input" do
      ShellIO
      |> stub(:prompt, fn _x -> "1" end)

      state = %{foo: "bar"}
      assert {"1", state} == Products.prompt_for_product(state)
    end
  end

  describe "handle_products/1" do
    test "invalid product" do
      Display
      |> expect(:main_menu, 1, fn x -> x end)

      {:ok, state} = State.initial_state()
      message = capture_io("c", fn -> Products.handle_product({"x", state}) end)
      expected = File.read!(Path.expand("../data/products/products_invalid_option.txt", __DIR__))
      assert message == expected
    end

    test "product not available" do
      Display
      |> expect(:main_menu, 1, fn x -> x end)

      state = %{products: [%{id: 1, stock: 0}]}
      message = capture_io("c", fn -> Products.handle_product({"1", state}) end)
      expected = File.read!(Path.expand("../data/products/products_out_of_stock.txt", __DIR__))
      assert message == expected
    end

    test "valid product" do
      CashRegister
      |> stub(:checkout, fn x -> x end)

      {:ok, state} = State.initial_state()

      result = Products.handle_product({"1", state})

      assert %{
               product: %{
                 id: 1,
                 name: "Coke",
                 price: %Money{amount: 115, currency: :GBP},
                 stock: 1
               }
             } = result
    end
  end

  describe "deliver_product/1" do
    test "message for yes" do
      Display
      |> expect(:main_menu, 1, fn x -> x end)

      {:ok, state} = State.initial_state()
      state = Map.put(state, :product, List.first(state.products))
      message = capture_io(fn -> Products.deliver_product({:yes, state}) end)

      expected =
        File.read!(Path.expand("../data/products/products_deliver_product_yes.txt", __DIR__))

      assert message == expected
    end

    test "actions for yes" do
      Display
      |> expect(:main_menu, 1, fn x -> x end)

      {:ok, state} = State.initial_state()
      state = Map.put(state, :product, List.first(state.products))
      result = Products.deliver_product({:yes, state})

      assert %{
               product: nil,
               products: products
             } = result

      assert List.first(products) |> Map.get(:stock) == 0
    end

    test "actions for no" do
      Display
      |> expect(:main_menu, 1, fn x -> x end)

      {:ok, state} = State.initial_state()
      state = Map.put(state, :product, List.first(state.products))
      result = Products.deliver_product({:no, state})

      assert %{
               product: nil,
               products: products
             } = result

      assert List.first(products) |> Map.get(:stock) == 1
    end
  end
end
