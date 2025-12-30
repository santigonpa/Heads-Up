defmodule HeadsUpWeb.IncidentLive.Index do
  use HeadsUpWeb, :live_view

  alias HeadsUp.Incidents
  alias HeadsUp.Categories
  import HeadsUp.CustomComponents

  def mount(_params, _sesion, socket) do
    # IO.inspect(self(), label: "Mount")
    socket = assign(socket, :category_options, Categories.category_names_and_slugs())

    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    # IO.inspect(self(), label: "Handle params")

    socket =
      socket
      |> stream(:incidents, Incidents.filter_incidents(params),
        page_title: "Incidents",
        reset: true
      )
      |> assign(:form, to_form(params))

    {:noreply, socket}
  end

  def render(assigns) do
    # IO.inspect(self(), label: "Render")

    ~H"""
    <div class="incident-index">
      <.headline>
        <.icon name="hero-trophy-mini" /> 25 Incidents Resolved This Month!
        <:tagline :let={emoji}>
          Thanks for pitching in. {emoji}
        </:tagline>
        <:tagline :let={emoji}>
          You're making a difference! {emoji}
        </:tagline>
      </.headline>

      <.filter_form form={@form} category_options={@category_options} />

      <div class="incidents" id="incidents" phx-update="stream">
        <div id="empty" class="no-results only:block hidden">
          No incidents found. Try changing your filters.
        </div>
        <.incident_card
          :for={{dom_id, incident} <- @streams.incidents}
          incident={incident}
          id={dom_id}
        />
      </div>
    </div>
    """
  end

  attr :incident, HeadsUp.Incidents
  attr :id, :string, required: true

  def incident_card(assigns) do
    ~H"""
    <.link navigate={~p"/incidents/#{@incident.id}"} id={@id}>
      <div class="card">
        <div class="category">
          {@incident.category.name}
        </div>
        <img src={@incident.image_path} />
        <h2>{@incident.name}</h2>
        <div class="details">
          <div class="priority">
            {@incident.priority}
          </div>
          <.badge status={@incident.status} />
        </div>
      </div>
    </.link>
    """
  end

  def filter_form(assigns) do
    ~H"""
    <.form for={@form} id="filter-form" phx-change="filter" phx-submit="filter">
      <.input
        field={@form[:q]}
        placeholder="Search..."
        autocomplete="off"
        phx-debounce="1000"
      />
      <.input
        type="select"
        field={@form[:status]}
        prompt="Status"
        options={[:pending, :resolved, :canceled]}
      />
      <.input
        type="select"
        field={@form[:category]}
        prompt="Category"
        options={@category_options}
      />
      <.input
        type="select"
        field={@form[:sort_by]}
        prompt="Sort By"
        options={[
          Name: "name",
          "Priority: High to Low": "priority_desc",
          "Priority: Low to High": "priority_asc",
          Category: "category"
        ]}
      />
      <.link patch={~p"/incidents"}>
        Reset
      </.link>
    </.form>
    """
  end

  def handle_event("filter", params, socket) do
    params =
      params
      |> Map.take(~w(q status sort_by category))
      |> Map.reject(fn {_, v} -> v == "" end)

    socket = push_patch(socket, to: ~p"/incidents?#{params}")

    {:noreply, socket}
  end
end
