defmodule VendingMachine.BalanceTest do
  use ExUnit.Case

  alias VendingMachine.Balance

  use Mimic

  describe "new/0" do
    test "new balance" do
      assert {:ok, %Money{amount: 0, currency: :GBP}} = Balance.new()
    end
  end

  describe "debit/2" do
    test "decrease balance" do
      assert %Money{amount: 1, currency: :GBP} = Balance.debit(Money.new(3), Money.new(2))
    end
  end

  describe "credit/2" do
    test "increse balance" do
      assert %Money{amount: 5, currency: :GBP} = Balance.credit(Money.new(3), Money.new(2))
    end
  end

  describe "is_enough/1" do
    test "has bigger balance" do
      assert Balance.is_enough(Money.new(2))
    end

    test "has balanced balance" do
      assert Balance.is_enough(Money.new(0))
    end

    test "has no balance" do
      refute Balance.is_enough(Money.new(-1))
    end
  end
end
