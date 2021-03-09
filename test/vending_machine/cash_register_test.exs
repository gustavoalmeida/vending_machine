defmodule VendingMachine.CashRegisterTest do
  use ExUnit.Case

  alias VendingMachine.State
  alias VendingMachine.Coins
  alias VendingMachine.CashRegister
  alias VendingMachine.Display

  import ExUnit.CaptureIO

  use Mimic

  describe "checkout/1" do
    test "succeed and deliver the product and change" do
      {:ok, state} = State.initial_state()
      product = state.products |> List.first()

      state =
        state
        |> Map.put(:product, product)
        |> Map.put(:balance, Money.new(2))

      Coins
      |> expect(:prompt_for_coin, 1, fn _ -> {"1", state} end)

      Display
      |> expect(:main_menu, 1, fn x -> x end)

      message = capture_io(fn -> CashRegister.checkout(state) end)
      expected = File.read!(Path.expand("../data/cash_register/checkout_ok.txt", __DIR__))
      assert message == expected
    end

    test "return coins with not enough change" do
      {:ok, state} = State.initial_state()
      product = state.products |> List.first()
      coin = state.coins |> Enum.find(&(&1.name == "£2"))

      state =
        state
        |> Map.put(:product, product)
        |> Map.update!(:coins, fn coins ->
          coins |> Enum.map(&Map.put(&1, :count, 0))
        end)

      Coins
      |> expect(:prompt_for_coin, 1, fn state ->
        {"#{coin.id}", state}
      end)

      Display
      |> expect(:main_menu, 1, fn x -> x end)

      message = capture_io(fn -> CashRegister.checkout(state) end)

      expected =
        File.read!(Path.expand("../data/cash_register/checkout_return_coins.txt", __DIR__))

      assert message == expected
    end
  end
end
