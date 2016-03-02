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

  def test(_, %{path: path}) do
    {dirname, filename, ext} = deconstruct_path(path)

    desired_filename = filename
      |> String.replace(~r/([A-Z])/, "_\\g{1}")
      |> String.replace(~r/\W/, "_")
      |> String.replace(~r/\A_/, "")
      |> String.replace(~r/[_]+/, "_")
      |> String.downcase

    desired_path = reconstruct_path(dirname, desired_filename, ext)

    if String.equivalent?(path, desired_path) do
      []
    else
      [error(path,  desired_path)]
    end
  end

  defp error(path, desired_path) do
    %Error{
      rule:     __MODULE__,
      message:  "Rename #{path} to #{desired_path}",
      line: 0,
    }
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
