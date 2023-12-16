defmodule ExplorerWeb.ApiDocsViewTest do
  use ExplorerWeb.ConnCase, async: false

  alias ExplorerWeb.APIDocsView

  describe "api_url/1" do
    setup do
      original = Application.get_env(:explorer_web, ExplorerWeb.Endpoint)

      on_exit(fn -> Application.put_env(:explorer_web, ExplorerWeb.Endpoint, original) end)

      :ok
    end

    test "adds slash before path" do
      Application.put_env(:explorer_web, ExplorerWeb.Endpoint,
        url: [scheme: "https", host: "lux.com", port: 9999, path: "/chain/dog"]
      )

      assert APIDocsView.api_url() == "https://lux.com/chain/dog/api"
    end

    test "does not add slash to empty path" do
      Application.put_env(:explorer_web, ExplorerWeb.Endpoint,
        url: [scheme: "https", host: "lux.com", port: 9999, path: ""]
      )

      assert APIDocsView.api_url() == "https://lux.com/api"
    end

    test "localhost return with port" do
      Application.put_env(:explorer_web, ExplorerWeb.Endpoint,
        url: [scheme: "http", host: "localhost"],
        http: [port: 9999]
      )

      assert APIDocsView.api_url() == "http://localhost:9999/api"
    end
  end

  describe "lux_url/1" do
    setup do
      original = Application.get_env(:explorer_web, ExplorerWeb.Endpoint)

      on_exit(fn -> Application.put_env(:explorer_web, ExplorerWeb.Endpoint, original) end)

      :ok
    end

    test "set_path = true returns url with path" do
      Application.put_env(:explorer_web, ExplorerWeb.Endpoint,
        url: [scheme: "https", host: "lux.com", path: "/eth/mainnet"]
      )

      assert APIDocsView.lux_url(true) == "https://lux.com/eth/mainnet"
    end

    test "set_path = false returns url w/out path" do
      Application.put_env(:explorer_web, ExplorerWeb.Endpoint,
        url: [scheme: "https", host: "lux.com", path: "/eth/mainnet"]
      )

      assert APIDocsView.lux_url(false) == "https://lux.com"
    end
  end

  describe "eth_rpc_api_url/1" do
    setup do
      original = Application.get_env(:explorer_web, ExplorerWeb.Endpoint)

      on_exit(fn -> Application.put_env(:explorer_web, ExplorerWeb.Endpoint, original) end)

      :ok
    end

    test "adds slash before path" do
      Application.put_env(:explorer_web, ExplorerWeb.Endpoint,
        url: [scheme: "https", host: "lux.com", port: 9999, path: "/chain/dog"]
      )

      assert APIDocsView.eth_rpc_api_url() == "https://lux.com/chain/dog/api/eth-rpc"
    end

    test "does not add slash to empty path" do
      Application.put_env(:explorer_web, ExplorerWeb.Endpoint,
        url: [scheme: "https", host: "lux.com", port: 9999, path: ""]
      )

      assert APIDocsView.eth_rpc_api_url() == "https://lux.com/api/eth-rpc"
    end

    test "localhost return with port" do
      Application.put_env(:explorer_web, ExplorerWeb.Endpoint,
        url: [scheme: "http", host: "localhost"],
        http: [port: 9999]
      )

      assert APIDocsView.eth_rpc_api_url() == "http://localhost:9999/api/eth-rpc"
    end
  end
end
