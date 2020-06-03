defmodule TealTest do
  use ExUnit.Case
  doctest Teal

  test "greets the world" do
    assert Teal.hello() == :world
  end
end
