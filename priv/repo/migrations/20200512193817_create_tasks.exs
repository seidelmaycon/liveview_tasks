defmodule TaskManager.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :name, :string
      add :done, :boolean, default: false, null: false

      timestamps()
    end

  end
end
