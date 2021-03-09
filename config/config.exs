import Config

config :money,
  default_currency: :GBP

config :vending_machine,
  products_path: "../../data/products.csv",
  coins_path: "../../data/coins.csv"

import_config "#{Mix.env()}.exs"
