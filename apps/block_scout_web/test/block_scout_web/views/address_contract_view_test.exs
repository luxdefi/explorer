defmodule ExplorerWeb.AddressContractViewTest do
  use ExplorerWeb.ConnCase, async: true

  alias ExplorerWeb.AddressContractView

  doctest ExplorerWeb.AddressContractView

  describe "format_optimization_text/1" do
    test "returns \"true\" for the boolean true" do
      assert AddressContractView.format_optimization_text(true) == "true"
    end

    test "returns \"false\" for the boolean false" do
      assert AddressContractView.format_optimization_text(false) == "false"
    end
  end
end
