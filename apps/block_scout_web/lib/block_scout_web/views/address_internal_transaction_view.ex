defmodule ExplorerWeb.AddressInternalTransactionView do
  use ExplorerWeb, :view

  alias ExplorerWeb.AccessHelper
  alias Explorer.Chain.Address

  def format_current_filter(filter) do
    case filter do
      "to" -> gettext("To")
      "from" -> gettext("From")
      _ -> gettext("All")
    end
  end
end
