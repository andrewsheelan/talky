defmodule Talky.DeviceActivityTest do
  use Talky.ModelCase

  alias Talky.DeviceActivity

  @valid_attrs %{assigned_date: "some content", details: "some content", duration: "some content", user_id: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = DeviceActivity.changeset(%DeviceActivity{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = DeviceActivity.changeset(%DeviceActivity{}, @invalid_attrs)
    refute changeset.valid?
  end
end
