defmodule AuthApi.Accounts do
  alias AuthApi.Repo
  alias AuthApi.Accounts.User
  alias AuthApi.Accounts.Todo
  alias Bcrypt
  import Ecto.Query

  # Kullanıcı kaydı
  def register_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  # Kullanıcı kimlik doğrulama
  def authenticate_user(username, password) do
    user = Repo.get_by(User, username: username)

    if user && Bcrypt.verify_pass(password, user.password_hash) do
      {:ok, user}
    else
      {:error, :invalid_credentials}
    end
  end

  def update_username(user, new_username) do
    user
    |> User.change_username_changeset(%{username: new_username})
    |> Repo.update()
  end

  def get_user!(id) do
    Repo.get!(User, id)
  end

  # Todo işlemleri
  def create_todo(attrs) do
    %Todo{}
    |> Todo.changeset(attrs)
    |> Repo.insert()
  end

  def update_todo(todo, attrs) do
    todo
    |> Todo.changeset(attrs)
    |> Repo.update()
  end

  def delete_todo(todo) do
    Repo.delete(todo)
  end

  def get_user_todos(user_id) do
    Repo.all(from t in Todo, where: t.user_id == ^user_id)
  end
end
