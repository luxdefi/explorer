defmodule ExplorerWeb.SmartContractControllerTest do
  use ExplorerWeb.ConnCase

  import Mox

  alias Explorer.Chain.{Address, Hash}
  alias Explorer.Factory

  setup :set_mox_from_context

  setup :verify_on_exit!

  describe "GET index/3" do
    test "returns not found for nonexistent address" do
      nonexistent_address_hash = Hash.to_string(Factory.address_hash())
      path = smart_contract_path(ExplorerWeb.Endpoint, :index, hash: nonexistent_address_hash)

      conn =
        build_conn()
        |> put_req_header("x-requested-with", "xmlhttprequest")
        |> get(path)

      assert html_response(conn, 404)
    end

    test "error for invalid address" do
      path = smart_contract_path(ExplorerWeb.Endpoint, :index, hash: "0x00", type: :regular, action: :read)

      conn =
        build_conn()
        |> put_req_header("x-requested-with", "xmlhttprequest")
        |> get(path)

      assert conn.status == 422
    end

    test "only responds to ajax requests", %{conn: conn} do
      smart_contract = insert(:smart_contract, contract_code_md5: "123")

      path = smart_contract_path(ExplorerWeb.Endpoint, :index, hash: smart_contract.address_hash)

      conn = get(conn, path)

      assert conn.status == 404
    end

    test "lists the smart contract read only functions" do
      token_contract_address = insert(:contract_address)

      insert(:smart_contract, address_hash: token_contract_address.hash, contract_code_md5: "123")

      blockchain_get_function_mock()

      path =
        smart_contract_path(ExplorerWeb.Endpoint, :index,
          hash: token_contract_address.hash,
          type: :regular,
          action: :read
        )

      conn =
        build_conn()
        |> put_req_header("x-requested-with", "xmlhttprequest")
        |> get(path)

      assert conn.status == 200
      refute conn.assigns.read_only_functions == []
    end

    test "lists [] proxy read only functions if no verified implementation" do
      token_contract_address = insert(:contract_address)

      insert(:smart_contract,
        address_hash: token_contract_address.hash,
        abi: [
          %{
            "type" => "function",
            "stateMutability" => "view",
            "payable" => false,
            "outputs" => [%{"type" => "address", "name" => ""}],
            "name" => "implementation",
            "inputs" => [],
            "constant" => true
          }
        ],
        contract_code_md5: "123"
      )

      get_eip1967_implementation_zero_addresses()

      path =
        smart_contract_path(ExplorerWeb.Endpoint, :index,
          hash: token_contract_address.hash,
          type: :proxy,
          action: :read
        )

      conn =
        build_conn()
        |> put_req_header("x-requested-with", "xmlhttprequest")
        |> get(path)

      assert conn.status == 200
      assert conn.assigns.read_only_functions == []
    end

    test "lists [] proxy read only functions if no verified eip-1967 implementation" do
      token_contract_address = insert(:contract_address)

      insert(:smart_contract,
        address_hash: token_contract_address.hash,
        abi: [
          %{
            "type" => "function",
            "stateMutability" => "nonpayable",
            "payable" => false,
            "outputs" => [%{"type" => "address", "name" => "", "internalType" => "address"}],
            "name" => "implementation",
            "inputs" => [],
            "constant" => false
          }
        ],
        contract_code_md5: "123"
      )

      blockchain_get_implementation_mock()

      path =
        smart_contract_path(ExplorerWeb.Endpoint, :index,
          hash: token_contract_address.hash,
          type: :proxy,
          action: :read
        )

      conn =
        build_conn()
        |> put_req_header("x-requested-with", "xmlhttprequest")
        |> get(path)

      assert conn.status == 200
      assert conn.assigns.read_only_functions == []
    end

    test "lists [] proxy read only functions if no verified eip-1967 implementation and eth_getStorageAt returns not normalized address hash" do
      token_contract_address = insert(:contract_address)

      insert(:smart_contract,
        address_hash: token_contract_address.hash,
        abi: [
          %{
            "type" => "function",
            "stateMutability" => "nonpayable",
            "payable" => false,
            "outputs" => [%{"type" => "address", "name" => "", "internalType" => "address"}],
            "name" => "implementation",
            "inputs" => [],
            "constant" => false
          }
        ],
        contract_code_md5: "123"
      )

      blockchain_get_implementation_mock_2()

      path =
        smart_contract_path(ExplorerWeb.Endpoint, :index,
          hash: token_contract_address.hash,
          type: :proxy,
          action: :read
        )

      conn =
        build_conn()
        |> put_req_header("x-requested-with", "xmlhttprequest")
        |> get(path)

      assert conn.status == 200
      assert conn.assigns.read_only_functions == []
    end
  end

  describe "GET show/3" do
    test "returns not found for nonexistent address" do
      nonexistent_address_hash = Address.checksum(Hash.to_string(Factory.address_hash()))

      path =
        smart_contract_path(
          ExplorerWeb.Endpoint,
          :show,
          nonexistent_address_hash,
          function_name: "get",
          args: []
        )

      conn =
        build_conn()
        |> put_req_header("x-requested-with", "xmlhttprequest")
        |> get(path)

      assert html_response(conn, 404)
    end

    test "error for invalid address" do
      path =
        smart_contract_path(
          ExplorerWeb.Endpoint,
          :show,
          "0x00",
          function_name: "get",
          args: []
        )

      conn =
        build_conn()
        |> put_req_header("x-requested-with", "xmlhttprequest")
        |> get(path)

      assert conn.status == 422
    end

    test "only responds to ajax requests", %{conn: conn} do
      smart_contract = insert(:smart_contract, contract_code_md5: "123")

      path =
        smart_contract_path(
          ExplorerWeb.Endpoint,
          :show,
          Address.checksum(smart_contract.address_hash),
          function_name: "get",
          args: []
        )

      conn = get(conn, path)

      assert conn.status == 404
    end

    test "fetch the function value from the blockchain" do
      address = insert(:contract_address)
      smart_contract = insert(:smart_contract, address_hash: address.hash, contract_code_md5: "123")

      blockchain_get_function_mock()

      path =
        smart_contract_path(
          ExplorerWeb.Endpoint,
          :show,
          Address.checksum(smart_contract.address_hash),
          function_name: "get",
          method_id: "6d4ce63c",
          args_count: 0,
          args: []
        )

      conn =
        build_conn()
        |> put_req_header("x-requested-with", "xmlhttprequest")
        |> get(path)

      assert conn.status == 200

      assert %{
               function_name: "get",
               layout: false,
               outputs: [%{"type" => "uint256", "value" => 0}]
             } = conn.assigns
    end
  end

  defp blockchain_get_function_mock do
    expect(
      EthereumJSONRPC.Mox,
      :json_rpc,
      fn [%{id: id, method: _, params: [%{data: _, to: _}, _]}], _options ->
        {:ok, [%{id: id, jsonrpc: "2.0", result: "0x0000000000000000000000000000000000000000000000000000000000000000"}]}
      end
    )
  end

  defp blockchain_get_implementation_mock do
    expect(EthereumJSONRPC.Mox, :json_rpc, fn %{
                                                id: 0,
                                                method: "eth_getStorageAt",
                                                params: [
                                                  _,
                                                  "0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc",
                                                  "latest"
                                                ]
                                              },
                                              _options ->
      {:ok, "0xcebb2CCCFe291F0c442841cBE9C1D06EED61Ca02"}
    end)
  end

  defp blockchain_get_implementation_mock_2 do
    expect(EthereumJSONRPC.Mox, :json_rpc, fn %{
                                                id: 0,
                                                method: "eth_getStorageAt",
                                                params: [
                                                  _,
                                                  "0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc",
                                                  "latest"
                                                ]
                                              },
                                              _options ->
      {:ok, "0x000000000000000000000000cebb2CCCFe291F0c442841cBE9C1D06EED61Ca02"}
    end)
  end

  defp mock_empty_logic_storage_pointer_request do
    expect(EthereumJSONRPC.Mox, :json_rpc, fn %{
                                                id: 0,
                                                method: "eth_getStorageAt",
                                                params: [
                                                  _,
                                                  "0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc",
                                                  "latest"
                                                ]
                                              },
                                              _options ->
      {:ok, "0x0000000000000000000000000000000000000000000000000000000000000000"}
    end)
  end

  defp mock_empty_beacon_storage_pointer_request(mox) do
    expect(mox, :json_rpc, fn %{
                                id: 0,
                                method: "eth_getStorageAt",
                                params: [
                                  _,
                                  "0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50",
                                  "latest"
                                ]
                              },
                              _options ->
      {:ok, "0x0000000000000000000000000000000000000000000000000000000000000000"}
    end)
  end

  defp mock_empty_eip_1822_storage_pointer_request(mox) do
    expect(mox, :json_rpc, fn %{
                                id: 0,
                                method: "eth_getStorageAt",
                                params: [
                                  _,
                                  "0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7",
                                  "latest"
                                ]
                              },
                              _options ->
      {:ok, "0x0000000000000000000000000000000000000000000000000000000000000000"}
    end)
  end

  defp mock_empty_oz_storage_pointer_request(mox) do
    expect(mox, :json_rpc, fn %{
                                id: 0,
                                method: "eth_getStorageAt",
                                params: [
                                  _,
                                  "0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3",
                                  "latest"
                                ]
                              },
                              _options ->
      {:ok, "0x0000000000000000000000000000000000000000000000000000000000000000"}
    end)
  end

  def get_eip1967_implementation_zero_addresses do
    mock_empty_logic_storage_pointer_request()
    |> mock_empty_beacon_storage_pointer_request()
    |> mock_empty_oz_storage_pointer_request()
    |> mock_empty_eip_1822_storage_pointer_request()
  end
end
