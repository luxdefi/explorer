defmodule ExplorerWeb.InternalTransactionView do
  use ExplorerWeb, :view

  alias Explorer.Chain.InternalTransaction

  import ExplorerWeb.Gettext

  @doc """
  Returns the formatted string for the type of the internal transaction.

  When the type is `call`, we return the formatted string for the call type.

  Examples:

  iex> ExplorerWeb.InternalTransactionView.type(%Explorer.Chain.InternalTransaction{type: :reward})
  "Reward"

  iex> ExplorerWeb.InternalTransactionView.type(%Explorer.Chain.InternalTransaction{type: :call, call_type: :delegatecall})
  "Delegate Call"
  """
  def type(%InternalTransaction{type: :call, call_type: :call}), do: gettext("Call")
  def type(%InternalTransaction{type: :call, call_type: :callcode}), do: gettext("Call Code")
  def type(%InternalTransaction{type: :call, call_type: :delegatecall}), do: gettext("Delegate Call")
  def type(%InternalTransaction{type: :call, call_type: :staticcall}), do: gettext("Static Call")
  def type(%InternalTransaction{type: :create}), do: gettext("Create")
  def type(%InternalTransaction{type: :create2}), do: gettext("Create2")
  def type(%InternalTransaction{type: :selfdestruct}), do: gettext("Self-Destruct")
  def type(%InternalTransaction{type: :reward}), do: gettext("Reward")
end
