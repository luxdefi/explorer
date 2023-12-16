defmodule ExplorerWeb.API.V2 do
  @moduledoc """
    API V2 context
  """

  def enabled? do
    Application.get_env(:explorer_web, __MODULE__)[:enabled]
  end
end
