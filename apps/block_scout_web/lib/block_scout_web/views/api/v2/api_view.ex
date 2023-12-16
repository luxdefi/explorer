defmodule ExplorerWeb.API.V2.ApiView do
  def render("message.json", %{message: message}) do
    %{
      "message" => message
    }
  end
end
