# EldCache

EldCache is a simple in-memory caching system for Elixir, using **GenServer** and **ETS (Erlang Term Storage)**. It allows storing temporary values and setting a **Time-To-Live (TTL)** for automatic expiration.

## 🚀 Features

- Store values in the cache with or without expiration.
- Retrieve values from the cache.
- Check the remaining TTL of an item.
- Automatically remove expired items.

## 📦 Installation

Clone this repository and install dependencies:

```sh
git clone https://github.com/victor-palha/eld_cache.git
cd eld_cache
```

## 🏗️ Usage

### Storing a value
```elixir
EldCache.put(:key, "my_value", 5000)  # Expires in 5 seconds
```

### Retrieving a value
```elixir
EldCache.get(:key)  # Returns {:ok, "my_value"} if exists, or :not_found if not
```

## 🔥 Running in IEx

To quickly test, run:

```sh
iex -S mix
```

And try the commands:

```elixir
EldCache.put(:test, [%{name: "John Doe", age: 22}], 3000)
EldCache.get(:test)
```

## 🌍 Using EldCache in Distributed Systems

EldCache can be used across multiple nodes in an Elixir cluster. To connect nodes and use the cache remotely:

1. Start nodes with names:

```sh
iex --sname node1 -S mix
iex --sname node2 -S mix
```

2. Connect the nodes:

```elixir
Node.connect(:node2@your-hostname)
```

3. Use `:rpc` to call EldCache from another node:

```elixir
:rpc.call(:node2@your-hostname, EldCache.Cache, :put, [:shared_key, "distributed_value", 10000])
:rpc.call(:node2@your-hostname, EldCache.Cache, :get, [:shared_key])
```

This allows EldCache to function as a distributed cache across multiple Elixir nodes.

---

## 🛠️ How does it work internally?

EldCache uses a **GenServer** to manage caching logic and an ETS table for efficient storage:

- **ETS**: Stores values along with the expiration timestamp.
- **GenServer**: Manages insertion, retrieval, and automatic expiration.
- **Supervisor**: Ensures EldCache restarts if it crashes.

---

Made with 💜 in Elixir.