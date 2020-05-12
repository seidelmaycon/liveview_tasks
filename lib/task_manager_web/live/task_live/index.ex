defmodule TaskManagerWeb.TaskLive.Index do
  use TaskManagerWeb, :live_view

  alias TaskManager.Board

  @impl true
  def mount(_params, _session, socket) do
    Board.subscribe()

    {:ok, fetch_tasks(socket)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tasks")
    |> assign(:task, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    task = Board.get_task!(id)
    Board.delete_task(task)

    {:noreply, fetch_tasks(socket)}
  end

  def handle_event("toggle", %{"id" => id}, socket) do
    task = Board.get_task!(id)
    Board.update_task(task, %{done: !task.done})
    {:noreply, fetch_tasks(socket)}
  end

  def handle_event("add", %{"task" => task}, socket) do
    Board.create_task(task)

    {:noreply, fetch_tasks(socket)}
  end

  @impl true
  def handle_info({Board, [:task | _], _}, socket) do
    {:noreply, fetch_tasks(socket)}
  end

  defp fetch_tasks(socket) do
    assign(socket, tasks: Board.list_tasks())
  end
end
