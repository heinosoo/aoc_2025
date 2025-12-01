import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile
import tempo/duration
import tempo/instant

pub type TestCase {
  TestCase(file: String, expected: String)
}

pub fn check(cases: List(TestCase), solver: fn(String) -> String) {
  let total = list.length(cases)
  let successful = cases |> list.count(check_case(_, solver))

  case total - successful {
    0 ->
      { "All test cases successful: " <> int.to_string(total) }
      |> greenln()

    failed ->
      { "Failed test cases: " <> int.to_string(failed) }
      |> redln()
  }
}

fn check_case(input: TestCase, solver: fn(String) -> String) -> Bool {
  input.file
  |> string.pad_end(40, "-")
  |> string.pad_start(60, "-")
  |> io.println()

  let time_start = instant.now()
  let solution = input.file |> readlines() |> solver
  let timer_delta = instant.since(time_start)

  { "Time: " <> timer_delta |> duration.format }
  |> io.println()

  { "Solution: " <> solution }
  |> io.println()

  case input.expected == solution {
    True -> {
      greenln("Correct\n")
      True
    }
    False -> {
      redln("Expected: " <> input.expected <> "\n")
      False
    }
  }
}

/// TIMED 
const color_green = "\u{001b}[38;5;2m"

const color_red = "\u{001b}[38;5;9m"

const color_reset = "\u{001b}[0m"

fn greenln(text: String) -> Nil {
  { color_green <> text <> color_reset }
  |> io.println()
}

fn redln(text: String) -> Nil {
  { color_red <> text <> color_reset }
  |> io.println()
}

fn readlines(filename: String) -> String {
  let assert Ok(input) = filename |> simplifile.read()
  input |> string.trim
}
