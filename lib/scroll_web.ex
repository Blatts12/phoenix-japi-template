defmodule ScrollWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use ScrollWeb, :controller
      use ScrollWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: ScrollWeb
      use PhoenixSwagger

      import PhoenixSwagger.Schema
      import Plug.Conn
      import ScrollWeb.ControllerHelpers
      import ScrollWeb.Gettext

      alias Scroll.Types
      alias ScrollWeb.Router.Helpers, as: Routes
      alias PhoenixSwagger.JapiBody

      def render_list_or_pagination(conn, template, %Scrivener.Page{} = data) do
        render(conn, template,
          data: data.entries,
          pagination: [
            total_entries: data.total_entries,
            total_pages: data.total_pages,
            page: data.page_number,
            page_size: data.page_size
          ]
        )
      end

      def render_list_or_pagination(conn, template, %Paginator.Page{metadata: metadata} = data) do
        render(conn, template,
          data: data.entries,
          pagination: [
            after: metadata.after,
            before: metadata.before,
            limit: metadata.limit
          ]
        )
      end

      def render_list_or_pagination(conn, template, data) do
        render(conn, template, data: data)
      end
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/scroll_web/templates",
        namespace: ScrollWeb

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      # Include shared imports and aliases for views
      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      import ScrollWeb.Gettext
    end
  end

  defp view_helpers do
    quote do
      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View
      import ScrollWeb.ErrorHelpers
      import ScrollWeb.Gettext

      alias ScrollWeb.Router.Helpers, as: Routes
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
