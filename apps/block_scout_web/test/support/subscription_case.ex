defmodule ExplorerWeb.SubscriptionCase do
  @moduledoc """
  This module defines the test case to be used by GraphQL subscription tests.
  """

  use ExUnit.CaseTemplate

  import Phoenix.ChannelTest, only: [connect: 2]

  @endpoint ExplorerWeb.Endpoint

  using do
    quote do
      # Import conveniences for testing with channels
      use ExplorerWeb.ChannelCase
      use Absinthe.Phoenix.SubscriptionTest, schema: ExplorerWeb.Schema
    end
  end

  @dialyzer {:nowarn_function, __ex_unit_setup_0: 1}
  setup do
    {:ok, socket} = connect(ExplorerWeb.UserSocket, %{})
    {:ok, socket} = Absinthe.Phoenix.SubscriptionTest.join_absinthe(socket)

    {:ok, socket: socket}
  end
end
