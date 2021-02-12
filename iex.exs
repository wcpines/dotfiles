# ~/.iex.exs
# https://stackoverflow.com/a/37911985/4667820
Application.put_env(:elixir, :ansi_enabled, true)

# http://samuelmullen.com/articles/customizing_elixirs_iex/
timestamp = fn ->
  {_date, {hour, minute, _second}} = :calendar.local_time()

  [hour, minute]
  |> Enum.map(&String.pad_leading(Integer.to_string(&1), 2, "0"))
  |> Enum.join(":")
end

IEx.configure(
  colors: [
    syntax_colors: [
      number: :yellow,
      atom: :cyan,
      string: :green,
      boolean: :red,
      nil: [:magenta, :bright]
    ],
    ls_directory: :cyan,
    ls_device: :yellow,
    doc_code: :green,
    doc_inline_code: :magenta,
    doc_headings: [:cyan, :underline],
    doc_title: [:cyan, :bright, :underline]
  ],
  default_prompt:
    "#{IO.ANSI.green()}%prefix#{IO.ANSI.reset()} " <>
      "[#{IO.ANSI.magenta()}#{timestamp.()}#{IO.ANSI.reset()} " <>
      ":: #{IO.ANSI.cyan()}%counter#{IO.ANSI.reset()}] >",
  alive_prompt:
    "#{IO.ANSI.green()}%prefix#{IO.ANSI.reset()} " <>
      "(#{IO.ANSI.yellow()}%node#{IO.ANSI.reset()}) " <>
      "[#{IO.ANSI.magenta()}#{timestamp.()}#{IO.ANSI.reset()} " <>
      ":: #{IO.ANSI.cyan()}%counter#{IO.ANSI.reset()}] >",
  history_size: 50,
  inspect: [
    pretty: true,
    limit: :infinity,
    width: 80
  ],
  width: 80
)
