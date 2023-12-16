defmodule ExplorerWeb.CommonComponentsView do
  use ExplorerWeb, :view

  def balance_percentage_enabled?(total_supply) do
    Application.get_env(:explorer_web, :show_percentage) && total_supply > 0
  end
end
