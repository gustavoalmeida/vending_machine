defmodule VendingMachine.DisplayTest do
  use ExUnit.Case

  alias VendingMachine.Display
  alias VendingMachine.Products
  alias VendingMachine.Settings

  import ExUnit.CaptureIO

  use Mimic

  describe "welcome/0" do
    test "show welcome message" do
      expected = File.read!(Path.expand("../data/display/welcome.txt", __DIR__))
      welcome = capture_io(fn -> Display.welcome() end)
      assert welcome == expected
    end
  end

  describe "show_main_menu/0" do
    test "show the main menu" do
      main_menu = capture_io(fn -> Display.show_main_menu() end)
      expected = File.read!(Path.expand("../data/display/main_menu.txt", __DIR__))
      assert main_menu == expected
    end
  end

  describe "handle_main_menu/1" do
    test "show option product" do
      Products
      |> expect(:display, 1, fn _ -> "products" end)
      |> expect(:prompt_for_product, 1, fn x -> x end)
      |> expect(:handle_product, 1, fn x -> x end)

      assert "products" == Display.handle_main_menu({"1", %{}})
    end

    test "show option settings" do
      Settings
      |> expect(:display, 1, fn _ -> "settings" end)
      |> expect(:prompt_for_settings, 1, fn x -> x end)
      |> expect(:handle_settings, 1, fn x -> x end)

      assert "settings" == Display.handle_main_menu({"2", %{}})
    end

    test "option cancel" do
      result = capture_io(fn -> Display.handle_main_menu({"c", %{}}) end)
      expected = File.read!(Path.expand("../data/display/main_menu_cancel.txt", __DIR__))
      assert result == expected
    end
  end
end
