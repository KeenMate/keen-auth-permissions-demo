defmodule KeenAuthPermissionsDemo.User.Verification do
  alias Simplificator3000.RandomHelpers
  alias KeenAuthPermissions.Error.{ErrorStruct}

  @type token_type() :: :email_verification | :password_reset

  @random_length 24

  @spec generate_token(
          conn :: Plug.Conn.t(),
          token_type :: token_type(),
          user_id :: non_neg_integer()
        ) :: binary()
  def generate_token(conn, token_type, user_id) do
    Phoenix.Token.sign(conn, type_salt(token_type), %{
      user_id: user_id,
      random_string: RandomHelpers.random_string(@random_length)
    })
  end

  @spec verify_token(conn :: Plug.Conn.t(), token_type :: token_type(), token :: binary()) ::
          {:ok, term()} | {:error, term()}
  def verify_token(conn, token_type, token) do
    Phoenix.Token.verify(conn, type_salt(token_type), token) |> parse_result()
  end

  defp type_salt(token_type) do
    case token_type do
      :email_verification -> "email verification"
      :password_reset -> "password reset"
    end
  end

  defp parse_result({:error, reason}) do
    case reason do
      :invalid -> {:error, ErrorStruct.create(:invalid, "Token is invalid")}
      :expired -> {:error, ErrorStruct.create(:expired, "Token is expired")}
      :missing -> {:error, ErrorStruct.create(:missing, "Token not provided")}
    end
  end

  defp parse_result(val), do: val
end
