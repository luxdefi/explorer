defmodule ExplorerWeb.VerifiedContractsView do
  use ExplorerWeb, :view

  import ExplorerWeb.AddressView, only: [balance: 1]
  import ExplorerWeb.Tokens.OverviewView, only: [total_supply_usd: 1]
  alias ExplorerWeb.WebRouter.Helpers

  def format_current_filter(filter) do
    case filter do
      "solidity" -> gettext("Solidity")
      "vyper" -> gettext("Vyper")
      "yul" -> gettext("Yul")
      _ -> gettext("All")
    end
  end
end
