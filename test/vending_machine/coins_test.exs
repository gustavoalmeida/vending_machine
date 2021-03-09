defmodule VendingMachine.CoinsTest do
  use ExUnit.Case

  alias VendingMachine.State
  alias VendingMachine.Coins
  alias Mix.Shell.IO, as: ShellIO

  import ExUnit.CaptureIO

  use Mimic

  describe "display/1" do
    test "show coins menu" do
      {:ok, state} = State.initial_state()
      coins = capture_io(fn -> Coins.display(state) end)
      expected = File.read!(Path.expand("../data/coins/coins_menu.txt", __DIR__))
      assert coins == expected
    end
  end

  describe "prompt_for_coins/1" do
    test "ask for coins menu option" do
      message = capture_io([input: "c"], fn -> Coins.prompt_for_coin(%{}) end)
      expected = File.read!(Path.expand("../data/coins/coins_prompt.txt", __DIR__))
      assert message == expected
    end

    test "handle input" do
      ShellIO
      |> stub(:prompt, fn _x -> "1" end)

      state = %{foo: "bar"}
      assert {"1", state} == Coins.prompt_for_coin(state)
    end
  end

  describe "handle_coins/1" do
    test "invalid coins" do
      {:ok, state} = State.initial_state()

      ShellIO
      |> stub(:prompt, fn _x -> "1" end)

      result = Coins.handle_coin({"c", state})
      assert %{coins: [h | _]} = result
      assert %{count: 2, id: 1} = h
    end

    test "valid coins" do
      {:ok, state} = State.initial_state()

      ShellIO
      |> stub(:prompt, fn x -> x end)

      result = Coins.handle_coin({"2", state})

      assert %{
               added_coins: [
                 %{count: 3, id: 2, name: "2p", value: %Money{amount: 2, currency: :GBP}}
               ],
               balance: %Money{amount: 2, currency: :GBP},
               coins: [
                 %{count: 1, id: 1, name: "1p", value: %Money{amount: 1, currency: :GBP}},
                 %{count: 4, id: 2, name: "2p", value: %Money{amount: 2, currency: :GBP}},
                 %{count: 2, id: 3, name: "5p", value: %Money{amount: 5, currency: :GBP}},
                 %{count: 5, id: 4, name: "10p", value: %Money{amount: 10, currency: :GBP}},
                 %{count: 2, id: 5, name: "20p", value: %Money{amount: 20, currency: :GBP}},
                 %{count: 2, id: 6, name: "50p", value: %Money{amount: 50, currency: :GBP}},
                 %{count: 9, id: 7, name: "£1", value: %Money{amount: 100, currency: :GBP}},
                 %{count: 10, id: 8, name: "£2", value: %Money{amount: 200, currency: :GBP}}
               ]
             } = result
    end
  end
end
