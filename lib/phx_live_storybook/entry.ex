defmodule PhxLiveStorybook.Entry do
  def live_component, do: component(live: true)

  def component(opts \\ [live: false]) do
    quote do
      alias PhxLiveStorybook.Components.Variation

      def storybook_type, do: :component
      def live_component?, do: Keyword.get(unquote(opts), :live)

      def public_name do
        call(:name, fn ->
          __MODULE__
          |> Module.split()
          |> Enum.at(-1)
          |> Macro.underscore()
          |> String.split("_")
          |> Enum.map_join(" ", &String.capitalize/1)
        end)
      end

      def public_component, do: call(:component)
      def public_function, do: call(:function)
      def public_description, do: call(:description, fn -> "" end)
      def public_icon, do: call(:icon)
      def public_variations, do: call(:variations, fn -> [] end)

      defp call(fun, fallback \\ fn -> nil end, args \\ []) do
        if Kernel.function_exported?(__MODULE__, fun, length(args)) do
          apply(__MODULE__, fun, args)
        else
          apply(fallback, args)
        end
      end
    end
  end

  @doc """
  Convenience helper for using the functions above.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
