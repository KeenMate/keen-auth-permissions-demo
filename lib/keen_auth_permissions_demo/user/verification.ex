defmodule KeenAuthPermissionsDemo.User.Verification do
  alias Simplificator3000.RandomHelpers

  @token_salt "email verification"
  @random_length 24

  def generate_token(conn, user_id) do
    Phoenix.Token.sign(conn, @token_salt, %{
      user_id: user_id,
      random_string: RandomHelpers.random_string(@random_length)
    })
  end

  def verify_token(conn, token) do
    Phoenix.Token.verify(conn, @token_salt, token)
  end
end
