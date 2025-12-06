import gleam/int
import gleam/list
import gleam/result
import gleam/string
import util/testing.{TestCase, check}

pub fn main() {
  [
    TestCase("input/day_06/test_01.txt", "4277556"),
    TestCase("input/day_06/input.txt", "6757749566978"),
  ]
  |> check(solution)
}

fn solution(input: String) -> String {
  input |> parse |> list.map(do_math) |> int.sum() |> int.to_string()
}

fn do_math(column: List(String)) -> Int {
  case column {
    ["*", single] -> single |> int.parse() |> result.unwrap(0)
    ["*", ..numbers] ->
      numbers
      |> list.map(int.parse)
      |> result.values()
      |> list.fold(1, int.multiply)
    ["+", ..numbers] ->
      numbers
      |> list.map(int.parse)
      |> result.values()
      |> int.sum()
    _ -> 0
  }
}

fn parse(input: String) -> List(List(String)) {
  {
    use line <- list.map(input |> string.split("\n") |> list.reverse())
    line |> string.split(" ") |> list.filter(fn(a) { a != "" })
  }
  |> list.transpose()
}
