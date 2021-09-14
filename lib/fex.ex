defmodule Fex do
  @moduledoc """
  Documentation for `Fex`.

  This is an experimental package - do not use in production!

  Many Elixir functions are returning two types of tuples:
  - {:ok, data}
  - {:error, error}

  Together they maps quite closely to "either" structure.
  Idea is to instead of using the `case` function(s) to
  check was operation successfull:

  ```
    case File.read("list.json") do
      {:ok, json} ->
        case Jason.decode(json) do
              {:ok, data} ->
                data
                |> Enum.sum()

              {:error, msg} ->
                Logger.error("Error occurred")
                IO.inspect(msg)
                0
            end

      {:error, msg} ->
        Logger.error("Error occurred")
        IO.inspect(msg)
        0
    end
  ```

  we could use functions that are operating on
  "either" looking structures:

  ```
    File.read("list.json") do
    |> Fex.chain(&Jason.decode/1)
    |> Fex.apply(&Enum.sum/1)
    |> Fex.fold(&(&1), fn msg ->
        Logger.error("Error occurred")
        IO.inspect(msg)
        0
    end)
  ```

  Above approach gives some advatanges over the
  "usual" approach:
  - developer has freedom to decide when to handle
    the "error" case, which makes it easier to divide
    code to dirty and pure parts
  - error cases can be grouped together
  - code is easier to reason about with a little bit
    of understanding about the "either" idea
  """

  @doc """
  Maps list of results using `Enum.map/2`

  ## Examples

      iex> Fex.map({:ok, [1, 2]}, &(&1 + 2))
      {:ok, [3, 4]}

      iex> Fex.map({:error, "Error message"}, &(&1 + 2))
      {:error, "Error message"}
  """
  def map({:ok, data}, iteration_fn) do
    {:ok, Enum.map(data, iteration_fn)}
  end

  def map({:error, error}, _iteration_fn), do: {:error, error}

  @doc """
  Applies function over data

  ## Examples

      iex> Fex.apply({:ok, [1, 2]}, &Enum.sum/1)
      {:ok, 3}

      iex> Fex.map({:error, "Error message"}, &Enum.sum/1)
      {:error, "Error message"}
  """
  def apply({:ok, data}, function) do
    {:ok, function.(data)}
  end

  def apply({:error, error}, _function), do: {:error, error}

  @doc """
  Like apply but doesn't wrap function in the "either" format.
  It relies on the fact that applied function will return the
  "either" format.

  Useful when you have an "either" structure already and you
  need to pass it to function that returns another "either"
  structure(using apply would cause "nesting" of eithers).

  ## Examples

      iex> Fex.chain({:ok, "{}"}, &Jason.decode/1)
      {:ok, %{}}

      iex> Fex.chain({:error, "Error message"}, &Jason.decode/1)
      {:error, "Error message"}
  """
  def chain({:ok, data}, function), do: function.(data)
  def chain({:error, error}, _function), do: {:error, error}

  @doc """
  When you would like to extract the pure value out of the "either"
  struct.

  ## Examples

      iex> Fex.fold({:ok, 5}, &(&1), &(&1))
      5

      iex> Fex.fold({:error, "Error message"},  &(&1), &(&1))
      "Error message"
  """
  def fold({:ok, data}, success_fn, _error_fn), do: success_fn.(data)
  def fold({:error, error}, _success_fn, error_fn), do: error_fn.(error)
end
