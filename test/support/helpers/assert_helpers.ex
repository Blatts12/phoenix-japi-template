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

  defmacro assert_count_difference(resource, [with: with_value], do: block) do
    quote do
      before_value = unquote(resource) |> Scroll.Repo.aggregate(:count)
      unquote(block)
      after_value = unquote(resource) |> Scroll.Repo.aggregate(:count)
      assert before_value + unquote(with_value) == after_value
    end
  end

  defmacro refute_count_difference(resource, do: block) do
    quote do
      before_value = unquote(resource) |> Scroll.Repo.aggregate(:count)
      unquote(block)
      after_value = unquote(resource) |> Scroll.Repo.aggregate(:count)
      assert before_value == after_value
    end
  end

  @spec assert_page_paginates(Plug.Conn.t(), String.t(), atom(), atom()) :: any()
  defmacro assert_page_paginates(conn, path, resource_atom, key) do
    quote do
      item_one = insert(unquote(resource_atom))
      item_two = insert(unquote(resource_atom))

      query_one = %{page: %{page: 1, page_size: 1}}

      # first page
      conn = get(unquote(conn), unquote(path), query_one)
      assert response = json_response(conn, 200)
      assert %{"next" => next} = response["links"]
      assert ritems = response["data"]
      assert length(ritems) == 1

      assert Enum.any?(ritems, fn ritem ->
               Map.get(ritem["attributes"], to_string(unquote(key))) ==
                 Map.get(item_one, unquote(key))
             end)

      # next page
      conn = get(conn, next)
      assert response = json_response(conn, 200)
      assert %{"prev" => prev} = response["links"]
      assert ritems = response["data"]
      assert length(ritems) == 1

      assert Enum.any?(ritems, fn ritem ->
               Map.get(ritem["attributes"], to_string(unquote(key))) ==
                 Map.get(item_two, unquote(key))
             end)

      # prev page
      conn = get(unquote(conn), prev)
      assert ritems = json_response(conn, 200)["data"]
      assert length(ritems) == 1

      assert Enum.any?(ritems, fn ritem ->
               Map.get(ritem["attributes"], to_string(unquote(key))) ==
                 Map.get(item_one, unquote(key))
             end)
    end
  end

  @spec assert_cursor_paginates(Plug.Conn.t(), String.t(), atom(), atom()) :: any()
  defmacro assert_cursor_paginates(conn, path, resource_atom, key) do
    quote do
      item_one = insert(unquote(resource_atom))
      item_two = insert(unquote(resource_atom))

      query_one = %{page: %{limit: 1}}

      # first page
      conn = get(unquote(conn), unquote(path), query_one)
      assert response = json_response(conn, 200)
      assert %{"next" => next} = response["links"]
      assert ritems = response["data"]
      assert length(ritems) == 1

      assert Enum.any?(ritems, fn ritem ->
               Map.get(ritem["attributes"], to_string(unquote(key))) ==
                 Map.get(item_one, unquote(key))
             end)

      # next page
      conn = get(conn, next)
      assert response = json_response(conn, 200)
      assert %{"prev" => prev} = response["links"]
      assert ritems = response["data"]
      assert length(ritems) == 1

      assert Enum.any?(ritems, fn ritem ->
               Map.get(ritem["attributes"], to_string(unquote(key))) ==
                 Map.get(item_two, unquote(key))
             end)

      # prev page
      conn = get(unquote(conn), prev, query_one)
      assert ritems = json_response(conn, 200)["data"]
      assert length(ritems) == 1

      assert Enum.any?(ritems, fn ritem ->
               Map.get(ritem["attributes"], to_string(unquote(key))) ==
                 Map.get(item_one, unquote(key))
             end)
    end
  end
end
