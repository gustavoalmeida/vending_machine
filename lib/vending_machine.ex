defmodule VendingMachine do
  @moduledoc """
  Main mModule that handle the vending machine CLI
  """

  use ExCLI.DSL, mix_task: :machine

  alias VendingMachine.Display
  alias VendingMachine.State

  name("Vending Machine")
  description("Start Machine")

  long_description("""
  This command starts the Vending Machine
  """)

  option(:verbose, help: "Increase the verbosity level", aliases: [:v], count: true)

  command :start do
    aliases([:s])
    description("Starts machine")

    long_description("""
    This starts the Vending Machine
    """)

    run _context do
      Display.welcome()

      with {:ok, state} <- State.initial_state() do
        Display.main_menu(state)
      end
    end
  end
end
