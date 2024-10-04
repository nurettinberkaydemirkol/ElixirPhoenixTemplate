defmodule AuthApiWeb.SessionController do
  use AuthApiWeb, :controller

  alias AuthApi.Accounts

  def create(conn, %{"username" => username, "password" => password}) do
    conn = fetch_session(conn)  # Oturumu fetch et

    case Accounts.authenticate_user(username, password) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)  # Kullanıcı ID'sini oturumda tutuyoruz
        |> put_status(:ok)
        |> json(%{message: "Logged in successfully"})

      {:error, :invalid_credentials} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid credentials"})
    end
  end

  # Mevcut kullanıcıyı almak için bir işlev
  def current_user(conn, _params) do
    conn = fetch_session(conn)  # Burada da oturumu fetch etmelisiniz
    user_id = get_session(conn, :user_id)

    if user_id do
      user = Accounts.get_user!(user_id)  # Kullanıcıyı al
      conn
      |> put_status(:ok)
      |> json(user)
    else
      conn
      |> put_status(:unauthorized)
      |> json(%{error: "Not authenticated"})
    end
  end
end
