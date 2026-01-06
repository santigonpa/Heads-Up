defmodule HeadsUpWeb.AdminUserLive.Index do
  use HeadsUpWeb, :live_view

  alias HeadsUp.Admin

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Listing Users")
      |> stream(:users, Admin.list_users())

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="admin-index">
      <.header>
        {@page_title}
      </.header>
      <.table
        id="users"
        rows={@streams.users}
      >
        <:col :let={{_dom_id, user}} label="Email">
          {user.email}
        </:col>
        <:col :let={{_dom_id, user}} label="Username">
          {user.username}
        </:col>
        <:col :let={{_dom_id, user}} label="Admin">
          {user.is_admin}
        </:col>
        <:action :let={{_dom_id, user}}>
          <%= if user.id != @current_user.id do %>
            <.link phx-click="toggle_admin" phx-value-id={user.id}>
              <%= if user.is_admin do %>
                Demote
              <% else %>
                Promote
              <% end %>
            </.link>
          <% end %>
        </:action>
      </.table>
    </div>
    """
  end

  def handle_event("toggle_admin", %{"id" => id}, socket) do
    user = Admin.get_user!(id)

    case Admin.toggle_admin(user) do
      {:ok, user} ->
        socket =
          socket
          |> put_flash(:info, "User updated succesfully!")
          |> stream_insert(:users, user)

        {:noreply, socket}
    end
  end
end
