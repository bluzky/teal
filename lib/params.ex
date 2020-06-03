defmodule Teal.Params do
  import Ecto.Changeset

  def parse(schema, params) do
    default = get_default(schema)
    types = get_type(schema)
    validator = get_validator(schema)
    required_field = get_required_fields(schema)

    # embed_fields =
    #   Enum.filter(types, fn {_, type} -> type == :embed end)
    #   |> Enum.map(&elem(&1, 0))

    # normal_fields =
    #   Enum.filter(types, fn {_, type} -> type != :embed end)
    #   |> Enum.into(%{})

    # embeds =
    #   Enum.map(embed_fields, fn field ->
    #     sub_params = params[field] || params[to_string(field)]
    #     {field, parse(schema[field], sub_params)}
    #   end)

    changeset =
      cast({default, types}, params, Map.keys(types))
      |> validate_required(required_field)

    changeset =
      Enum.reduce(validator, changeset, fn {field, {val_type, val_opts}}, cs ->
        apply(Ecto.Changeset, :"validate_#{val_type}", [cs, field, val_opts])
      end)

    if changeset.valid? do
      {:ok, apply_changes(changeset)}
    else
      {:error, changeset}
    end
  end

  defp get_default(schema) do
    default =
      Enum.map(schema, fn
        {field, opts} when is_list(opts) ->
          if Keyword.has_key?(opts, :default) do
            Keyword.get(opts, :default)
          else
            {field, nil}
          end

        {field, _type} ->
          {field, nil}
      end)

    Enum.into(default, %{})
  end

  defp get_type(schema) do
    types =
      Enum.map(schema, fn
        {field, type} when is_atom(type) ->
          {field, type}

        {field, opts} when is_list(opts) ->
          if Keyword.has_key?(opts, :type) do
            {field, Keyword.get(opts, :type)}
          else
            raise "Type is missing"
          end

        {field, sub} when is_map(sub) ->
          raise "Nested is not supported yet"
      end)

    Enum.into(types, Map.new())
  end

  defp get_validator(schema) do
    validators =
      Enum.map(schema, fn
        {field, opts} when is_list(opts) ->
          if Keyword.has_key?(opts, :validate) do
            {field, Keyword.get(opts, :validate)}
          else
            nil
          end

        _ ->
          nil
      end)

    Enum.filter(validators, &(not is_nil(&1)))
  end

  defp get_required_fields(schema) do
    Enum.filter(schema, fn
      {k, opts} when is_list(opts) ->
        Keyword.get(opts, :required) == true

      _ ->
        false
    end)
    |> Enum.map(&elem(&1, 0))
  end
end
