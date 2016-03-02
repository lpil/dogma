use Dogma.RuleBuilder

defrule Dogma.Rule.SnakeCaseFilename do
  @moduledoc """
  Checks if files are using the snake_case_format.

  Favors this:

  a_valid_filename.ex

  over these:

  AValidFilename.ex
  aValidFilename.ex
  a valid filename.ex
  a.valid.filename.ex
  a-valid-filename.ex
  """
  alias Dogma.Util.Name

  def test(_, %{path: path}) do
    {dirname, filename, ext} = deconstruct_path(path)
    if Name.snake_case?(filename) do
      []
    else
      [error(path, suggested_snake_case_path(dirname, filename, ext))]
    end
  end

  defp error(path, desired_path) do
    %Error{
      rule:     __MODULE__,
      message:  "Rename #{path} to #{desired_path}",
      line: 0,
    }
  end

  defp suggested_snake_case_path(dirname, filename, ext) do
    desired_filename = filename
    |> String.replace(~r/([A-Z])/, "_\\g{1}")
    |> String.replace(~r/\W/, "_")
    |> String.replace(~r/\A_/, "")
    |> String.replace(~r/[_]+/, "_")
    |> String.downcase

    reconstruct_path(dirname, desired_filename, ext)
  end

  defp deconstruct_path(path) do
    dirname = path |> Path.dirname
    ext = path |> Path.extname
    filename = path |> Path.basename(ext)

    {dirname, filename, ext}
  end

  defp reconstruct_path(".", filename, ext) do
    filename <> ext
  end

  defp reconstruct_path(dirname, filename, ext) do
    Path.join(dirname, filename) <> ext
  end

end
