defmodule SuperStoreWeb.ProductLive.New do
  use SuperStoreWeb, :live_view
  import SuperStoreWeb.CoreComponents
  alias SuperStore.Catalog.Product
  alias SuperStoreWeb.ProductLive.FormComponent

  def render(assigns) do
    ~H"""
    <.header>
      New Product
      <:subtitle>Use this form to create product records in your database.</:subtitle>
    </.header>

    <.live_component module={FormComponent} id="new-form" action={@live_action} product={%Product{}}>
      <h1>Creating a product</h1>
    </.live_component>

    <.back navigate={~p"/"}>Back to products</.back>
    """
  end
end
