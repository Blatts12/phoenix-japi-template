defmodule Scroll.Posts.Posts do
  @moduledoc false

  alias Scroll.Posts.Post

  use Scroll.SubcontextFunctions,
    struct: Post
end
