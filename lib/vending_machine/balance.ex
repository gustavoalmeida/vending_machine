defmodule VendingMachine.Balance do
  @moduledoc """
  Module that handle functionalities related with balance
  """

  def new() do
    {:ok, Money.new(0)}
  end

  def debit(balance, value) do
    Money.subtract(balance, value)
  end

  def credit(balance, value) do
    Money.add(balance, value)
  end

  @spec is_enough(Money.t()) :: boolean
  def is_enough(balance) do
    Money.zero?(balance) or Money.positive?(balance)
  end
end
