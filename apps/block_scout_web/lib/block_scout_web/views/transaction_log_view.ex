defmodule ExplorerWeb.TransactionLogView do
  use ExplorerWeb, :view
  @dialyzer :no_match

  import ExplorerWeb.AddressView, only: [decode: 2, implementation_name: 1, primary_name: 1]
end
