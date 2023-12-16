import Config

config :explorer_web, :sql_sandbox, true

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :explorer_web, ExplorerWeb.Endpoint,
  http: [port: 4002],
  secret_key_base: "27Swe6KtEtmN37WyEYRjKWyxYULNtrxlkCEKur4qoV+Lwtk8lafsR16ifz1XBBYj",
  server: true,
  pubsub_server: ExplorerWeb.PubSub,
  checksum_address_hashes: true

config :explorer_web, ExplorerWeb.Tracer, disabled?: false

config :logger, :explorer_web,
  level: :warn,
  path: Path.absname("logs/test/explorer_web.log")

# Configure wallaby
config :wallaby, screenshot_on_failure: true, driver: Wallaby.Chrome, js_errors: false

config :explorer_web, ExplorerWeb.Counters.BlocksIndexedCounter, enabled: false

config :explorer_web, ExplorerWeb.Counters.InternalTransactionsIndexedCounter, enabled: false

config :explorer_web, :captcha_helper, ExplorerWeb.TestCaptchaHelper

config :ueberauth, Ueberauth,
  providers: [
    auth0: {
      Ueberauth.Strategy.Auth0,
      [callback_url: "example.com/callback"]
    }
  ]
