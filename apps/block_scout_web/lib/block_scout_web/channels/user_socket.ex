defmodule ExplorerWeb.UserSocket do
  use Phoenix.Socket
  use Absinthe.Phoenix.Socket, schema: ExplorerWeb.Schema

  channel("addresses:*", ExplorerWeb.AddressChannel)
  channel("blocks:*", ExplorerWeb.BlockChannel)
  channel("exchange_rate:*", ExplorerWeb.ExchangeRateChannel)
  channel("rewards:*", ExplorerWeb.RewardChannel)
  channel("transactions:*", ExplorerWeb.TransactionChannel)
  channel("tokens:*", ExplorerWeb.TokenChannel)

  def connect(%{"locale" => locale}, socket) do
    {:ok, assign(socket, :locale, locale)}
  end

  def connect(_params, socket) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
