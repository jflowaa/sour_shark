defmodule SourSharkTest do
  use ExUnit.Case
  doctest SourShark

  test "greets the world" do
    assert SourShark.hello() == :world
  end
end
