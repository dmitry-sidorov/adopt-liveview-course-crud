defmodule SuperStoreWeb.ProductLive.FormComponent do
  alias SuperStore.Catalog
  alias SuperStore.Catalog.Product
  use SuperStoreWeb, :live_component

  def update(%{product: product} = assigns, socket) do
    form =
      Product.changeset(product)
      |> to_form()

    {:ok, socket |> assign(form: form) |> assign(assigns)}
  end

  def handle_event("validate", %{"product" => product_params}, socket) do
    form =
      socket.assigns.product
      |> Product.changeset(product_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, form: form)}
  end

  def handle_event("save", %{"product" => product_params}, socket) do
    save_product(socket, socket.assigns.action, product_params)
  end

  def save_product(socket, :new, product_params) do
    socket =
      case Catalog.create_product(product_params) do
        {:ok, %Product{} = product} ->
          put_flash(socket, :info, "Product ID #{product.id} created!")
          |> push_navigate(to: ~p"/")

        {:error, %Ecto.Changeset{} = changeset} ->
          form = to_form(changeset)

          socket
          |> assign(form: form)
          |> put_flash(:error, "Invalid product!")
      end

    {:noreply, socket}
  end

  def save_product(socket, :edit, product_params) do
    socket =
      case Catalog.update_product(socket.assigns.product, product_params) do
        {:ok, %Product{} = product} ->
          put_flash(socket, :info, "Product ID #{product.id} updated!")
          |> push_navigate(to: ~p"/")

          if patch = socket.assigns[:patch] do
            push_patch(socket, to: patch)
          else
            push_navigate(socket, to: ~p"/products/#{product.id}/edit")
          end

        {:error, %Ecto.Changeset{} = changeset} ->
          form = to_form(changeset)

          socket
          |> assign(form: form)
          |> put_flash(:error, "Invalid data!")
      end

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="bg-grey-100">
      <.form
        for={@form}
        phx-target={@myself}
        class="flex flex-col max-w-96 mx-auto bg-gray-100 p-24"
        phx-change="validate"
        phx-submit="save"
      >
        <%= render_slot(@inner_block) %>
        <.input field={@form[:name]} placeholder="Name" />
        <.input field={@form[:description]} placeholder="Description" />

        <.button type="submit">Send</.button>
      </.form>
    </div>
    """
  end
end
