defmodule ExplorerWeb.Cldr do
  @moduledoc """
  Cldr global configuration.
  """

  use Cldr,
    default_locale: "en",
    locales: ["en"],
    gettext: ExplorerWeb.Gettext,
    generate_docs: false,
    precompile_number_formats: ["#,###", "#,##0.##################", "#.#%", "#,##0"],
    providers: [Cldr.Number, Cldr.Unit]
end
