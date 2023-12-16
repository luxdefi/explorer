defmodule ExplorerWeb.Account.TagAddressView do
  use ExplorerWeb, :view

  import ExplorerWeb.AddressView, only: [trimmed_hash: 1]

  alias Explorer.Account.TagAddress
end
