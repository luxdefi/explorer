defmodule ExplorerWeb.Account.Api.V1.AuthenticateController do
  use ExplorerWeb, :controller

  import ExplorerWeb.Account.AuthController, only: [current_user: 1]

  alias ExplorerWeb.Models.UserFromAuth
  alias Explorer.Account.Identity

  action_fallback(ExplorerWeb.Account.Api.V1.FallbackController)

  def authenticate_get(conn, params) do
    authenticate(conn, params)
  end

  def authenticate_post(conn, params) do
    authenticate(conn, params)
  end

  defp authenticate(conn, params) do
    with {:sensitive_endpoints_api_key, api_key} when not is_nil(api_key) <-
           {:sensitive_endpoints_api_key, Application.get_env(:explorer_web, :sensitive_endpoints_api_key)},
         {:api_key, ^api_key} <- {:api_key, params["api_key"]},
         {:auth, %{id: uid} = current_user} <- {:auth, current_user(conn)},
         {:identity, %Identity{}} <- {:identity, UserFromAuth.find_identity(uid)} do
      conn
      |> put_status(200)
      |> json(current_user)
    end
  end
end
