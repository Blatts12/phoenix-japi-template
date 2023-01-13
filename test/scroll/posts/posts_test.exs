defmodule Scroll.Posts.PostsTest do
  use Scroll.DataCase

  alias Scroll.Posts
  alias Scroll.Posts.Post

  describe "list_posts/3" do
    test "returns empty list when there are no posts" do
      posts = Posts.list_posts()
      assert Enum.empty?(posts)
    end

    test "returns posts" do
      post = insert(:post)
      assert [received_post] = Posts.list_posts()
      assert received_post.id == post.id
    end
  end

  describe "get_post/2" do
    test "returns post" do
      post = insert(:post)
      assert Posts.get_post(post.id).id == post.id
    end
  end

  describe "create_post/1" do
    test "returns changeset error with invalid data" do
      attrs = params_with_assocs(:post, %{title: nil})
      assert {:error, %Ecto.Changeset{}} = Posts.create_post(attrs)
    end

    test "creates a user with valid data" do
      attrs = params_with_assocs(:post)
      assert {:ok, %Post{} = post} = Posts.create_post(attrs)
      assert post.title == attrs.title
    end
  end

  describe "update_post/2" do
    test "returns changeset error with invalid data" do
      post = insert(:post)
      attrs = params_for(:post) |> Map.put(:title, nil)
      assert {:error, %Ecto.Changeset{}} = Posts.update_post(post, attrs)
    end

    test "updates the post with valid data" do
      post = insert(:post)
      attrs = params_for(:post)
      assert {:ok, %Post{} = post} = Posts.update_post(post, attrs)
      assert post.title == attrs.title
    end
  end

  describe "delete_post/1" do
    test "deletes the post" do
      post = insert(:post)
      assert {:ok, %Post{}} = Posts.delete_post(post)
      assert nil == Posts.get_post(post.id)
    end
  end
end
