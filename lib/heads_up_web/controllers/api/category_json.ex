defmodule HeadsUpWeb.Api.CategoryJSON do
  def show(%{category: category}) do
    %{category: data(category)}
  end

  defp data(category) do
    %{
      id: category.id,
      name: category.name,
      category: category.slug,
      incidents:
        for(
          incident <- category.incident,
          do: %{incident: incident.name}
        )
    }
  end
end
