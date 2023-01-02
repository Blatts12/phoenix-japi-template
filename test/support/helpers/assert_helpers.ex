defmodule ScrollWeb.AssertHelpers do
  @moduledoc "Module containing helpers to assert values in tests"

  require ExUnit.Assertions

  @spec assert_ok(Plug.Conn.t()) :: boolean()
  def assert_ok(%Plug.Conn{} = conn) do
    assert_conn_status(conn, 200, "expected conn to contain status: 200 (OK)")
  end

  @spec assert_created(Plug.Conn.t()) :: boolean()
  def assert_created(%Plug.Conn{} = conn) do
    assert_conn_status(conn, 201, "expected conn to contain status: 201 (Created)")
  end

  @spec assert_no_content(Plug.Conn.t()) :: boolean()
  def assert_no_content(%Plug.Conn{} = conn) do
    assert_conn_status(conn, 204, "expected conn to contain status: 204 (No Content)")
  end

  @spec assert_unauthorized(Plug.Conn.t()) :: boolean()
  def assert_unauthorized(%Plug.Conn{} = conn) do
    assert_conn_status(conn, 401, "expected conn to contain status: 401 (Unauthorized)")
  end

  @spec assert_forbidden(Plug.Conn.t()) :: boolean()
  def assert_forbidden(%Plug.Conn{} = conn) do
    assert_conn_status(conn, 403, "expected conn to contain status: 403 (Forbidden)")
  end

  @spec assert_not_found(Plug.Conn.t()) :: boolean()
  def assert_not_found(%Plug.Conn{} = conn) do
    assert_conn_status(conn, 404, "expected conn to contain status: 404 (Not Found)")
  end

  @spec assert_unprocessable_entity(Plug.Conn.t()) :: boolean()
  def assert_unprocessable_entity(%Plug.Conn{} = conn) do
    assert_conn_status(conn, 422, "expected conn to contain status: 422 (Unprocessable Entity)")
  end

  @spec assert_conn_status(Plug.Conn.t(), integer(), String.t()) :: boolean()
  def assert_conn_status(conn, status, text) do
    ExUnit.Assertions.assert(%Plug.Conn{status: ^status} = conn, text)
  end
end
