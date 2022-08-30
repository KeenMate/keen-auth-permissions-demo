defmodule KeenAuthPermissionsDemo.User.Password do
  @spec hash_password(password :: binary) :: binary
  def hash_password(password) do
    Pbkdf2.hash_pwd_salt(password)
  end

  @spec verify_password(password :: binary, password_hash :: binary) :: boolean
  def verify_password(password, password_hash) do
    Pbkdf2.verify_pass(password, password_hash)
  end
end
