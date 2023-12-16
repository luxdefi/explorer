defmodule ExplorerWeb.Account.WatchlistAddressView do
  use ExplorerWeb, :view
  import ExplorerWeb.AddressView, only: [trimmed_hash: 1]
  import ExplorerWeb.WeiHelper, only: [format_wei_value: 2]

  def balance_ether(nil), do: ""

  def balance_ether(balance) do
    format_wei_value(balance, :ether)
  end
end
