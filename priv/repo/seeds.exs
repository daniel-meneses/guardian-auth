# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Twitterclone.Repo.insert!(%Twitterclone.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Twitterclone.Repo
alias Twitterclone.Accounts.User

Repo.insert! %User{
  first_name: "Daniel",
  last_name: "Meneses",
  email: "daniel@gmail.com",
  password_hash: "abc"
}

Repo.insert! %User{
  first_name: "Melanie",
  last_name: "Supan",
  email: "mel@gmail.com",
  password_hash: "abc"
}

Repo.insert! %User{
  first_name: "Dang",
  last_name: "Man",
  email: "dang@gmail.com",
  password_hash: "anc"
}
