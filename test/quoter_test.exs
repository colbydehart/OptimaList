defmodule Optimalist.QuoterTest do
  use Optimalist.DataCase

  alias Optimalist.Quoter
  alias Optimalist.Quoter.EstimateRequest

  @create_attrs %{cost: "120.5"}
  @update_attrs %{cost: "456.7"}
  @invalid_attrs %{cost: nil}

  def fixture(:estimate_request, attrs \\ @create_attrs) do
    {:ok, estimate_request} = Quoter.create_estimate_request(attrs)
    estimate_request
  end

  test "list_estimate_requests/1 returns all estimate_requests" do
    estimate_request = fixture(:estimate_request)
    assert Quoter.list_estimate_requests() == [estimate_request]
  end

  test "get_estimate_request! returns the estimate_request with given id" do
    estimate_request = fixture(:estimate_request)
    assert Quoter.get_estimate_request!(estimate_request.id) == estimate_request
  end

  test "create_estimate_request/1 with valid data creates a estimate_request" do
    assert {:ok, %EstimateRequest{} = estimate_request} = Quoter.create_estimate_request(@create_attrs)
    assert estimate_request.cost == "120.5"
  end

  test "create_estimate_request/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Quoter.create_estimate_request(@invalid_attrs)
  end

  test "update_estimate_request/2 with valid data updates the estimate_request" do
    estimate_request = fixture(:estimate_request)
    assert {:ok, estimate_request} = Quoter.update_estimate_request(estimate_request, @update_attrs)
    assert %EstimateRequest{} = estimate_request
    assert estimate_request.cost == "456.7"
  end

  test "update_estimate_request/2 with invalid data returns error changeset" do
    estimate_request = fixture(:estimate_request)
    assert {:error, %Ecto.Changeset{}} = Quoter.update_estimate_request(estimate_request, @invalid_attrs)
    assert estimate_request == Quoter.get_estimate_request!(estimate_request.id)
  end

  test "delete_estimate_request/1 deletes the estimate_request" do
    estimate_request = fixture(:estimate_request)
    assert {:ok, %EstimateRequest{}} = Quoter.delete_estimate_request(estimate_request)
    assert_raise Ecto.NoResultsError, fn -> Quoter.get_estimate_request!(estimate_request.id) end
  end

  test "change_estimate_request/1 returns a estimate_request changeset" do
    estimate_request = fixture(:estimate_request)
    assert %Ecto.Changeset{} = Quoter.change_estimate_request(estimate_request)
  end
end
