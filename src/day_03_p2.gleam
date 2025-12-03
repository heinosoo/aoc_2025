import gleam/int
import gleam/list
import gleam/result
import gleam/string
import util/testing.{TestCase, check}

pub fn main() {
  [
    TestCase("input/day_03/test_01.txt", "3121910778619"),
    TestCase("input/day_03/input.txt", "175304218462560"),
  ]
  |> check(solution)
}

fn solution(input: String) -> String {
  input
  |> string.split("\n")
  |> list.map(max_jolts(_, 12))
  |> result.values()
  |> list.map(int.parse)
  |> result.values()
  |> int.sum()
  |> int.to_string()
}

fn max_jolts(line: String, batteries: Int) -> Result(String, Nil) {
  case batteries, string.length(line) < batteries {
    // We don't need more batteries, solution found!
    0, _ -> Ok("")

    // Not enough batteries available
    _, True -> Error(Nil)

    _, _ -> {
      // Use the first digit that gives Ok(something) below.
      use d <- list.find_map(string.to_graphemes("987654321"))

      case string.split_once(line, d) {
        // No such digit left
        Error(_) -> Error(Nil)
        // Try to find the solution with the rest of the batteries
        Ok(#(_, rest)) ->
          max_jolts(rest, batteries - 1) |> result.map(string.append(d, _))
      }
    }
  }
}
