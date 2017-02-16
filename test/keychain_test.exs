defmodule KeychainTest do
  use ExUnit.Case
  doctest Keychain

  test "Get a Keypair" do
    assert {:ok, _} =Keychain.generate_pair
  end
end
