defmodule ExplorerWeb.RecentTransactionsController do
  use ExplorerWeb, :controller

  import Explorer.Chain.SmartContract, only: [burn_address_hash_string: 0]

  alias Explorer.{Chain, PagingOptions}
  alias Explorer.Chain.Hash
  alias Phoenix.View

  {:ok, burn_address_hash} = Chain.string_to_address_hash(burn_address_hash_string())
  @burn_address_hash burn_address_hash

  def index(conn, _params) do
    if ajax?(conn) do
      recent_transactions =
        Chain.recent_collated_transactions(true,
          necessity_by_association: %{
            :block => :required,
            [created_contract_address: :names] => :optional,
            [from_address: :names] => :optional,
            [to_address: :names] => :optional,
            [created_contract_address: :smart_contract] => :optional,
            [from_address: :smart_contract] => :optional,
            [to_address: :smart_contract] => :optional
          },
          paging_options: %PagingOptions{page_size: 5}
        )

      transactions =
        Enum.map(recent_transactions, fn transaction ->
          %{
            transaction_hash: Hash.to_string(transaction.hash),
            transaction_html:
              View.render_to_string(ExplorerWeb.TransactionView, "_tile.html",
                transaction: transaction,
                burn_address_hash: @burn_address_hash,
                conn: conn
              )
          }
        end)

      json(conn, %{transactions: transactions})
    else
      unprocessable_entity(conn)
    end
  end
end
