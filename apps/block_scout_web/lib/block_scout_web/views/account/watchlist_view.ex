defmodule ExplorerWeb.Account.WatchlistView do
  use ExplorerWeb, :view

  alias ExplorerWeb.Account.WatchlistAddressView
  alias Explorer.Account.WatchlistAddress
  alias Explorer.Market
  alias Indexer.Fetcher.CoinBalanceOnDemand

  def coin_balance_status(address) do
    CoinBalanceOnDemand.trigger_fetch(address)
  end

  def exchange_rate do
    Market.get_coin_exchange_rate()
  end
end
