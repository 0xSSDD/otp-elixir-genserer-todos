# List is a genserver
defmodule Todo.List do
  use GenServer

  def items(list) do
    GenServer.call(list, :items)
  end

  def add(list, item) do
    GenServer.cast(list, {:add, item})
  end

  def update(list, item) do
    GenServer.cast(list, {:update, item})
  end

  ###
  # Genserver API (callbacks)
  ###
  def start_link(name) do
    GenServer.start_link(__MODULE__, name)
  end


  def init(name) do
    state = %{name: name, items: []}
    {:ok, state}
  end

  def handle_call(:items, _from, state) do
    {:reply, state.items, state}
  end

  def handle_cast({:add, item}, state) do
    state = %{state | items: [item | state.items]}
    {:noreply, state}
  end

  def handle_cast({:update, item}, state) do
    index = Enum.find_index(state.items, &(&1.id == item.id))
    items = List.replace_at(state.items, index, item)
    state = %{state | items: items}
    {:noreply, state}
  end

end
