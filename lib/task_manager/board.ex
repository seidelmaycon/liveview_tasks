defmodule TaskManager.Board do
  @moduledoc """
  The Board context.
  """

  import Ecto.Query, warn: false
  alias TaskManager.Repo

  alias TaskManager.Board.Task

  @topic inspect(__MODULE__)

  @spec list_tasks :: any
  def list_tasks do
    from(t in Task, order_by: t.done)
    |> Repo.all()
  end

  def get_task!(id), do: Repo.get!(Task, id)

  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
    |> broadcast_change([:task, :created])
  end

  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
    |> broadcast_change([:task, :updated])
  end

  def delete_task(%Task{} = task) do
    Repo.delete(task)
    |> broadcast_change([:task, :deleted])
  end

  def change_task(%Task{} = task, attrs \\ %{}) do
    Task.changeset(task, attrs)
  end

  @spec subscribe :: :ok | {:error, {:already_registered, pid}}
  def subscribe do
    Phoenix.PubSub.subscribe(TaskManager.PubSub, @topic)
  end

  defp broadcast_change({:ok, result}, event) do
    Phoenix.PubSub.broadcast(TaskManager.PubSub, @topic, {__MODULE__, event, result})
  end
end
