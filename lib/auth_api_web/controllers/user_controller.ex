defmodule AuthApiWeb.UserController do
  use AuthApiWeb, :controller
  alias AuthApi.Accounts
  require Logger


  def create(conn, %{"user" => user_params}) do
    Logger.info("Received user params: #{inspect(user_params)}")

    case Accounts.register_user(user_params) do
      {:ok, user} ->
        json(conn, %{message: "User created successfully", user: user})
      {:error, changeset} ->
        # Hata durumunda, hata mesajlarını düzgün bir formatta döndür
        errors =
          changeset.errors
          |> Enum.map(fn {field, {msg, _}} -> {Atom.to_string(field), msg} end)
          |> Enum.into(%{}) # Hataları bir harita (map) yapısına dönüştür

        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: errors})
    end
  end

  def update_username(conn, %{"id" => id, "username" => new_username}) do
    user = Accounts.get_user!(id)

    case Accounts.update_username(user, new_username) do
      {:ok, user} ->
        conn
        |> put_status(:ok)
        |> json(user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(changeset)
    end
  end

  def get_user(conn, %{"id" => id}) do
    try do
      user = AuthApi.Accounts.get_user!(id)
      Logger.info("Received user params: #{inspect(user)}")
      conn
      |> put_status(:ok)
      |> json(user)
    rescue
      Ecto.NoResultsError ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})
    end
  end

end
