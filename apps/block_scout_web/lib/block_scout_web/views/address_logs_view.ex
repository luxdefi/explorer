defmodule ExplorerWeb.AddressLogsView do
  use ExplorerWeb, :view

  alias Explorer.Chain.Address

  import ExplorerWeb.AddressView, only: [decode: 2]
end
