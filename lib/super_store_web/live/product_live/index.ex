defmodule SuperStoreWeb.ProductLive.Index do
  use SuperStoreWeb, :live_view
  alias SuperStore.Catalog

  def mount(_params, _session, socket) do
    socket = stream(socket, :products, Catalog.list_products())
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.table id="products" rows={@streams.products}>
      <:col :let={{_id, product}} label="Name"><%= product.name %></:col>
      <:col :let={{_id, product}} label="Description"><%= product.description %></:col>
    </.table>
    """
  end
end
