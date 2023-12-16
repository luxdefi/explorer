defmodule ExplorerWeb.Tokens.Instance.MetadataView do
  use ExplorerWeb, :view

  alias ExplorerWeb.Tokens.Instance.OverviewView

  def format_metadata(nil), do: ""

  def format_metadata(metadata), do: Poison.encode!(metadata, %{pretty: true})
end
