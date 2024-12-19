defmodule Game.Utils.PokeAPIClient do
  alias Req

  @moduledoc """

  to fetch all pokemon:
  Enum.to_list(1..1025) |> Enum.map(&(Game.Utils.PokeAPIClient.get_pokemon &1, true))

  to fetch all moves:
  Enum.to_list(1..919) |> Enum.map(&(Game.Utils.PokeAPIClient.get_move &1, true))
  """

  def list_pokemon(offset \\ 0, limit \\ 20) do
    fetch("/pokemon?offset=#{offset}&limit=#{limit}")
  end

  def get_pokemon(id, save_to_file? \\ false) do
    case fetch("/pokemon/#{id}") do
      {:ok, body} ->
        if save_to_file? do
          save_to_file(id, "pokemon", body)
        end

        {:ok, body}

      error ->
        error
    end
  end

  def get_move(id, save_to_file? \\ false) do
    case fetch("/move/#{id}") do
      {:ok, body} ->
        if save_to_file? do
          save_to_file(id, "moves", body)
        end

        {:ok, body}

      error ->
        error
    end
  end

  defp fetch(url) do
    case Req.get(base_url() <> url) do
      {:ok, %{status: 200, body: body}} ->
        {:ok, body}

      {:error, %{status: status_code}} ->
        {:error, "Request failed with status code: #{status_code}"}
    end
  end

  defp base_url(), do: Application.get_env(:game, Game.Utils.PokeAPIClient)[:base_url]
  defp file_path(), do: Application.get_env(:game, Game.Utils.PokeAPIClient)[:file_path]

  defp save_to_file(id, type, body) do
    id_str = Integer.to_string(id)
    # todo: sanitize allll this
    File.write!("#{file_path()}/#{type}/#{id_str}.json", body |> Jason.encode!())
  end
end
