defmodule Talky.DeviceActivityControllerTest do
  use Talky.ConnCase

  alias Talky.DeviceActivity
  @valid_attrs %{assigned_date: "some content", details: "some content", duration: "some content", user_id: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, device_activity_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing device activities"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, device_activity_path(conn, :new)
    assert html_response(conn, 200) =~ "New device activity"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, device_activity_path(conn, :create), device_activity: @valid_attrs
    assert redirected_to(conn) == device_activity_path(conn, :index)
    assert Repo.get_by(DeviceActivity, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, device_activity_path(conn, :create), device_activity: @invalid_attrs
    assert html_response(conn, 200) =~ "New device activity"
  end

  test "shows chosen resource", %{conn: conn} do
    device_activity = Repo.insert! %DeviceActivity{}
    conn = get conn, device_activity_path(conn, :show, device_activity)
    assert html_response(conn, 200) =~ "Show device activity"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, device_activity_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    device_activity = Repo.insert! %DeviceActivity{}
    conn = get conn, device_activity_path(conn, :edit, device_activity)
    assert html_response(conn, 200) =~ "Edit device activity"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    device_activity = Repo.insert! %DeviceActivity{}
    conn = put conn, device_activity_path(conn, :update, device_activity), device_activity: @valid_attrs
    assert redirected_to(conn) == device_activity_path(conn, :show, device_activity)
    assert Repo.get_by(DeviceActivity, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    device_activity = Repo.insert! %DeviceActivity{}
    conn = put conn, device_activity_path(conn, :update, device_activity), device_activity: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit device activity"
  end

  test "deletes chosen resource", %{conn: conn} do
    device_activity = Repo.insert! %DeviceActivity{}
    conn = delete conn, device_activity_path(conn, :delete, device_activity)
    assert redirected_to(conn) == device_activity_path(conn, :index)
    refute Repo.get(DeviceActivity, device_activity.id)
  end
end
