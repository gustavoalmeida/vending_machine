Mimic.copy(VendingMachine.Display)
Mimic.copy(VendingMachine.Settings)
Mimic.copy(VendingMachine.Coins)
Mimic.copy(VendingMachine.Products)
Mimic.copy(VendingMachine.CashRegister)
Mimic.copy(Mix.Shell.IO)

{:ok, _} = Application.ensure_all_started(:mimic)

ExUnit.start()
