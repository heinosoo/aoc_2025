import gleam/int
import gleam/list
import gleam/pair
import gleam/result
import gleam/string
import util/testing.{TestCase, check}

pub fn main() {
  [
    TestCase("input/day_01/test_1.txt", "3"),
    TestCase("input/day_01/input.txt", "1172"),
  ]
  |> check(solution)
}

fn solution(input: String) -> String {
  input
  |> string.split("\n")
  |> list.map(parse_line)
  |> result.values
  |> list.map_fold(50, fn(sum, rotation) { #(sum + rotation, sum + rotation) })
  |> pair.second
  |> list.count(fn(position) { position % 100 == 0 })
  |> int.to_string
}

fn parse_line(line: String) -> Result(Int, Nil) {
  line |> string.replace("L", "-") |> string.replace("R", "") |> int.parse
}
