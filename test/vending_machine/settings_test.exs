defmodule VendingMachine.SettingsTest do
  use ExUnit.Case

  alias VendingMachine.Settings
  alias VendingMachine.State
  alias VendingMachine.Display
  alias Mix.Shell.IO, as: ShellIO

  import ExUnit.CaptureIO

  use Mimic

  describe "display/1" do
    test "show settings menu" do
      settings = capture_io(fn -> Settings.display(%{}) end)
      expected = File.read!(Path.expand("../data/settings/settings_menu.txt", __DIR__))
      assert settings == expected
    end
  end

  describe "prompt_for_settings/1" do
    test "ask for setting menu option" do
      message = capture_io([input: "c"], fn -> Settings.prompt_for_settings(%{}) end)
      expected = File.read!(Path.expand("../data/settings/settings_prompt.txt", __DIR__))
      assert message == expected
    end

    test "handle input" do
      ShellIO
      |> stub(:prompt, fn _x -> "1" end)

      state = %{foo: "bar"}

      assert {"1", state} == Settings.prompt_for_settings(state)
    end
  end

  describe "handle_settings/1" do
    test "reloading product" do
      {:ok, %{products: products}} = State.initial_state()
      any_state = %{}

      Display
      |> expect(:main_menu, 1, fn x -> x end)

      result = Settings.handle_settings({"1", any_state})
      assert result.products == products
    end

    test "reloading coins" do
      {:ok, %{coins: coins}} = State.initial_state()
      any_state = %{}

      Display
      |> expect(:main_menu, fn x -> x end)

      result = Settings.handle_settings({"2", any_state})
      assert result.coins == coins
    end

    test "cancelling" do
      any_state = %{coins: "coins", products: "products"}

      Display
      |> expect(:main_menu, fn x -> x end)

      result = Settings.handle_settings({"c", any_state})
      assert result == any_state
    end
  end
end
