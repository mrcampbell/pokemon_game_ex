defmodule Game.Pokemon do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pokemon" do
    field :name, :string
    field :type, :string
    field :base_experience, :integer
    field :height, :integer
    field :weight, :integer
    field :image, :string
    field :abilities, {:array, :string}
    field :stats, {:array, :map}
    field :moves, {:array, :string}
    field :species, :string
    field :evolutions, {:array, :string}
    field :description, :string

    timestamps()
  end
end
