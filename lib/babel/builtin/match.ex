defmodule Babel.Builtin.Match do
  @moduledoc false
  use Babel.Step

  @enforce_keys [:matcher]
  defstruct [:matcher]

  def new(matcher) do
    unless is_function(matcher, 1) do
      raise ArgumentError, "not an arity 1 function: #{inspect(matcher)}"
    end

    %__MODULE__{matcher: matcher}
  end

  @impl Babel.Step
  def apply(%__MODULE__{matcher: matcher} = step, %Babel.Context{current: input} = context) do
    nested = Babel.Applicable.apply(matcher.(input), context)

    Babel.Trace.new(step, input, nested.output, [nested])
  end

  @impl Babel.Step
  def inspect(%__MODULE__{} = step, opts) do
    Babel.Builtin.inspect(step, [:matcher], opts)
  end
end
