defmodule Optimalist.Quoter do
  @moduledoc """
  The boundary for the Quoter system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias Optimalist.Repo

  alias Optimalist.Quoter.EstimateRequest

  @doc """
  Returns the list of estimate_requests.

  ## Examples

      iex> list_estimate_requests()
      [%EstimateRequest{}, ...]

  """
  def list_estimate_requests do
    Repo.all(EstimateRequest)
  end

  @doc """
  Gets a single estimate_request.

  Raises `Ecto.NoResultsError` if the Estimate request does not exist.

  ## Examples

      iex> get_estimate_request!(123)
      %EstimateRequest{}

      iex> get_estimate_request!(456)
      ** (Ecto.NoResultsError)

  """
  def get_estimate_request!(id), do: Repo.get!(EstimateRequest, id)

  @doc """
  Creates a estimate_request.

  ## Examples

      iex> create_estimate_request(%{field: value})
      {:ok, %EstimateRequest{}}

      iex> create_estimate_request(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_estimate_request(attrs \\ %{}) do
    %EstimateRequest{}
    |> estimate_request_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a estimate_request.

  ## Examples

      iex> update_estimate_request(estimate_request, %{field: new_value})
      {:ok, %EstimateRequest{}}

      iex> update_estimate_request(estimate_request, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_estimate_request(%EstimateRequest{} = estimate_request, attrs) do
    estimate_request
    |> estimate_request_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a EstimateRequest.

  ## Examples

      iex> delete_estimate_request(estimate_request)
      {:ok, %EstimateRequest{}}

      iex> delete_estimate_request(estimate_request)
      {:error, %Ecto.Changeset{}}

  """
  def delete_estimate_request(%EstimateRequest{} = estimate_request) do
    Repo.delete(estimate_request)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking estimate_request changes.

  ## Examples

      iex> change_estimate_request(estimate_request)
      %Ecto.Changeset{source: %EstimateRequest{}}

  """
  def change_estimate_request(%EstimateRequest{} = estimate_request) do
    estimate_request_changeset(estimate_request, %{})
  end

  defp estimate_request_changeset(%EstimateRequest{} = estimate_request, attrs) do
    estimate_request
    |> cast(attrs, [:cost])
    |> validate_required([:cost])
  end
end
