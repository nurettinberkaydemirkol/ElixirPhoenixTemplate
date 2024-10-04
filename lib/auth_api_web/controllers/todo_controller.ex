defmodule AuthApiWeb.TodoController do
  use AuthApiWeb, :controller
  alias AuthApi.{Repo, Accounts}

  def create(conn, %{"title" => title, "description" => description}) do
    conn = fetch_session(conn)
    user_id = get_session(conn, :user_id)

    case Accounts.create_todo(%{title: title, description: description, user_id: user_id}) do
      {:ok, todo} ->
        todo = Repo.preload(todo, :user) # user ilişkisinin preload edilmesi
        conn
        |> put_status(:created)
        |> json(todo)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: changeset.errors})
    end
  end

  def index(conn, _params) do
    conn = fetch_session(conn)
    user_id = get_session(conn, :user_id)

    todos = Accounts.list_todos(user_id)

    conn
    |> put_status(:ok)
    |> json(todos)
  end
end
