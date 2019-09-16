defmodule Twitterclone.UserTest do
  use Twitterclone.DataCase

  alias Twitterclone.User

  describe "friends" do
    alias Twitterclone.User.Friend

    @valid_attrs %{accepted: true, user_a_id: 42, user_b_id: 42}
    @update_attrs %{accepted: false, user_a_id: 43, user_b_id: 43}
    @invalid_attrs %{accepted: nil, user_a_id: nil, user_b_id: nil}

    def friend_fixture(attrs \\ %{}) do
      {:ok, friend} =
        attrs
        |> Enum.into(@valid_attrs)
        |> User.create_friend()

      friend
    end

    test "list_friends/0 returns all friends" do
      friend = friend_fixture()
      assert User.list_friends() == [friend]
    end

    test "get_friend!/1 returns the friend with given id" do
      friend = friend_fixture()
      assert User.get_friend!(friend.id) == friend
    end

    test "create_friend/1 with valid data creates a friend" do
      assert {:ok, %Friend{} = friend} = User.create_friend(@valid_attrs)
      assert friend.accepted == true
      assert friend.user_a_id == 42
      assert friend.user_b_id == 42
    end

    test "create_friend/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = User.create_friend(@invalid_attrs)
    end

    test "update_friend/2 with valid data updates the friend" do
      friend = friend_fixture()
      assert {:ok, %Friend{} = friend} = User.update_friend(friend, @update_attrs)
      assert friend.accepted == false
      assert friend.user_a_id == 43
      assert friend.user_b_id == 43
    end

    test "update_friend/2 with invalid data returns error changeset" do
      friend = friend_fixture()
      assert {:error, %Ecto.Changeset{}} = User.update_friend(friend, @invalid_attrs)
      assert friend == User.get_friend!(friend.id)
    end

    test "delete_friend/1 deletes the friend" do
      friend = friend_fixture()
      assert {:ok, %Friend{}} = User.delete_friend(friend)
      assert_raise Ecto.NoResultsError, fn -> User.get_friend!(friend.id) end
    end

    test "change_friend/1 returns a friend changeset" do
      friend = friend_fixture()
      assert %Ecto.Changeset{} = User.change_friend(friend)
    end
  end

  describe "posts" do
    alias Twitterclone.User.Post

    @valid_attrs %{likes: 42, message: "some message", views: 42}
    @update_attrs %{likes: 43, message: "some updated message", views: 43}
    @invalid_attrs %{likes: nil, message: nil, views: nil}

    def post_fixture(attrs \\ %{}) do
      {:ok, post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> User.create_post()

      post
    end

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert User.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert User.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      assert {:ok, %Post{} = post} = User.create_post(@valid_attrs)
      assert post.likes == 42
      assert post.message == "some message"
      assert post.views == 42
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = User.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      assert {:ok, %Post{} = post} = User.update_post(post, @update_attrs)
      assert post.likes == 43
      assert post.message == "some updated message"
      assert post.views == 43
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = User.update_post(post, @invalid_attrs)
      assert post == User.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = User.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> User.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = User.change_post(post)
    end
  end
end
