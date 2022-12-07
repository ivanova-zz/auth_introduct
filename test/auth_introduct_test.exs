defmodule AuthIntroductTest do
  use ExUnit.Case
  doctest AuthIntroduct

  test "greets the world" do
    assert AuthIntroduct.hello() == :world
  end
end
