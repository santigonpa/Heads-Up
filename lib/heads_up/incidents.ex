alias HeadsUp.Incidents.Incident
alias HeadsUp.Repo
import Ecto.Query
defmodule HeadsUp.Incidents do
  def list_incidents do
    Repo.all(Incident)
  end

  def get_incident!(id) do
    Repo.get!(Incident, id)
  end

  def urgent_incidents(incident) do
    Incident
    |> where(status: :pending)
    |> where([r], r.id != ^incident.id)
    |> order_by(asc: :priority)
    |> limit(3)
    |> Repo.all()
  end

  def filter_incidents(filter) do
    Incident
    |> where(status: ^filter["status"])
    |> where([r], ilike(r.name, ^"%#{filter["q"]}%"))
    |> order_by(:name)
    |> Repo.all()
  end
end
