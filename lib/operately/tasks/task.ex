defmodule Operately.Tasks.Task do
  use Operately.Schema

  schema "tasks" do
    belongs_to :creator, Operately.People.Person
    belongs_to :assignee, Operately.People.Person
    belongs_to :space, Operately.Groups.Group

    field :name, :string
    field :priority, :string
    field :size, :string
    field :description, :map
    field :due_date, :naive_datetime

    timestamps()
  end

  def changeset(attrs) do
    changeset(%__MODULE__{}, attrs)
  end

  def changeset(task, attrs) do
    task
    |> cast(attrs, [:name, :due_date, :description, :size, :priority, :creator_id, :assignee_id, :space_id])
    |> validate_required([:name, :due_date, :description, :size, :priority, :creator_id, :assignee_id, :space_id])
  end
end