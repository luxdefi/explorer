defmodule ExplorerWeb.UserSocketV2 do
  @moduledoc """
    Module to distinct new and old UI websocket connections
  """
  use Phoenix.Socket

  channel("addresses:*", ExplorerWeb.AddressChannel)
  channel("blocks:*", ExplorerWeb.BlockChannel)
  channel("exchange_rate:*", ExplorerWeb.ExchangeRateChannel)
  channel("rewards:*", ExplorerWeb.RewardChannel)
  channel("transactions:*", ExplorerWeb.TransactionChannel)
  channel("tokens:*", ExplorerWeb.TokenChannel)
  channel("zkevm_batches:*", ExplorerWeb.ZkevmConfirmedBatchChannel)

  def connect(_params, socket) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
