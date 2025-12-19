defmodule HeadsUpWeb.IncidentLive.Index do
  use HeadsUpWeb, :live_view

  alias HeadsUp.Incidents

  def mount(_params, _sesion, socket) do
    socket = assign(socket, :incidents, Incidents.list_incidents)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="incident-index">
      <div class="incidents">
        <.incident_card :for={incident <- @incidents} incident={incident}/>
      </div>
    </div>
    """
  end

  attr :incident, HeadsUp.Incidents
  def incident_card(assigns) do
    ~H"""
    <div class="card">
      <img src={@incident.image_path}/>
      <h2><%= @incident.name %></h2>
      <div class="details">
        <div class="name">
          <%= @incident.priority %>
        </div>
        <.badge status={@incident.status} />
      </div>
    </div>
    """
  end

  attr :status, :atom, required: true, values: [:pending, :resolved, :cancelled]
  def badge(assigns) do
    ~H"""
    <div class="rounded-md px-2 py-1 text-xs font-medium uppercase inline-block border text-lime-600 border-lime-600">
      <%= @status %>
    </div>
    """
  end
end
