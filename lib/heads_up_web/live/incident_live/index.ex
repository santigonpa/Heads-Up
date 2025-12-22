defmodule HeadsUpWeb.IncidentLive.Index do
  use HeadsUpWeb, :live_view

  alias HeadsUp.Incidents
  import HeadsUp.CustomComponents

  def mount(_params, _sesion, socket) do
    socket = assign(socket, incidents: Incidents.list_incidents, page_title: "Incidents")

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="incident-index">
      <.headline>
        <.icon name="hero-trophy-mini" />
        25 Incidents Resolved This Month!
        <:tagline :let={emoji}>
          Thanks for pitching in. <%= emoji %>
        </:tagline>
        <:tagline :let={emoji}>
          You're making a difference! <%= emoji %>
        </:tagline>
      </.headline>
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
end
