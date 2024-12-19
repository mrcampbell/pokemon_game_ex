defmodule Game.Utils.PokeAPIClient do
  alias Req

  def list_pokemon(offset \\ 0, limit \\ 20) do
    fetch("/pokemon?offset=#{offset}&limit=#{limit}")
  end

  def get_pokemon(id, save_to_file? \\ false) do
    case fetch("/pokemon/#{id}") do
      {:ok, body} ->
        if save_to_file? do
          save_to_file(id, body)
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

  defp save_to_file(id, body) do
    id_str = Integer.to_string(id)
    File.write!(file_path() <> id_str <> ".json", body |> Jason.encode!())
  end
end
