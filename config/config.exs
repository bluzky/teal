use Mix.Config

config :min,
  jwt: [
    alg: "HS256",
    secret_key: "my secret",
    ttl: 86400,
    issuer: "teal"
  ]
