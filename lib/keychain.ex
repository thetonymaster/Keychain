defmodule Keychain do
  @moduledoc """
  Provides functions to manage SSH key pairs
  """

  @ssh_keygen System.find_executable("ssh-keygen")
  @path Application.app_dir(:keychain, "keys") <> "/"
  @key @path <> "id_rsa"

  @doc """
  """
  def generate_pair(comment \\ "Keychain") do
    create_keys(comment)
    public = public_key()
    private = private_key()
    fingerprint = get_fingerprint()
    remove_keys()
    {:ok, %{public: public, private: private, fingerprint: fingerprint}}
  end

  @doc """
  Returns the content of the SSH public ket
  """
  def public_key do
    key = File.open!(@key <> ".pub",[:read])
    |> IO.read(:line)
    File.close(@key <> ".pub")
    key
  end

  @doc """
  Returns the content of the SSH public ket
  """
  def private_key do
    key = File.open!(@key,[:read])
    |> IO.read(:all)
    File.close(@key)
    key
  end

  defp create_keys(comment) do
    File.mkdir!(@path)
    args = ["-t", "rsa", "-b", "4096", "-f", @key, "-C", comment, "-N", ""]
    System.cmd(@ssh_keygen, args)
  end

  defp get_fingerprint do
    args = ["-lf", @key]
    {fingerprint, _} = System.cmd(@ssh_keygen, args)
    res = String.split(fingerprint, " ")
    Enum.at(res, 1)
  end

  defp remove_keys do
    File.rm_rf!(@path)
  end
end
