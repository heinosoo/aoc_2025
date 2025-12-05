import gleam/int
import gleam/list
import gleam/result
import gleam/string
import util/testing.{TestCase, check}

pub fn main() {
  [
    TestCase("input/day_05/test_01.txt", "14"),
    TestCase("input/day_05/input.txt", "336173027056994"),
  ]
  |> check(solution)
}

fn solution(input: String) -> String {
  let assert Ok(#(ranges, _)) = input |> string.split_once("\n\n")

  ranges
  |> string.split("\n")
  |> list.map(parse_range)
  |> result.values()
  |> list.fold([], add_range)
  |> list.fold(0, fn(sum, r) { sum + r.1 - r.0 + 1 })
  |> int.to_string()
}

fn parse_range(range: String) {
  use #(min, max) <- result.try(range |> string.split_once("-"))
  use min <- result.try(int.parse(min))
  use max <- result.try(int.parse(max))
  Ok(#(min, max))
}

fn add_range(fresh_list: List(#(Int, Int)), r: #(Int, Int)) {
  case fresh_list {
    [] -> [r]
    [f, ..] if r.1 < f.0 -> [r, ..fresh_list]
    [f, ..rest] if r.0 <= f.0 && f.1 <= r.1 -> add_range(rest, r)
    [f, ..rest] if f.1 < r.0 -> [f, ..add_range(rest, r)]
    [f, ..rest] if r.0 <= f.0 && r.1 <= f.1 -> add_range(rest, #(r.0, f.1))
    [f, ..rest] if f.0 <= r.0 && f.1 <= r.1 -> add_range(rest, #(f.0, r.1))
    [_, ..] -> fresh_list
  }
}
