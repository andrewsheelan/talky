defmodule Talky.Human do
  use Talky.Web, :model

  schema "humen" do
    field :human_api_id, :string
    field :access_token, :string
    field :public_token, :string
    field :sources, {:array, :string}
    belongs_to :user, Talky.User

    timestamps(inserted_at: :created_at)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:human_api_id, :access_token, :public_token, :sources])
    |> validate_required([:human_api_id, :access_token, :public_token, :sources])
  end
end
