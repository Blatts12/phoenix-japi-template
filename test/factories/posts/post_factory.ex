defmodule Scroll.Posts.PostFactory do
  @moduledoc false

  alias Scroll.Posts.Post

  defmacro __using__(_opts) do
    quote do
      def post_factory do
        %Post{
          title: sequence(:title, &"Title #{&1}"),
          content: "Content",
          user: build(:user)
        }
      end
    end
  end
end
