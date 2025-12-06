import gleam/int
import gleam/list
import gleam/result
import gleam/string
import util/testing.{TestCase, check}

pub fn main() {
  [
    TestCase("input/day_06/test_01.txt", "3263827"),
    TestCase("input/day_06/input.txt", "10603075273949"),
  ]
  |> check(solution)
}

fn solution(input: String) -> String {
  let assert [ops_line, ..number_lines] =
    input
    |> string.split("\n")
    |> list.reverse()

  number_lines
  |> parse_numbers()
  |> list.chunk(result.is_ok)
  |> list.filter(fn(column) { column != [Error(Nil)] })
  |> list.map(result.values)
  |> list.zip(parse_ops(ops_line))
  |> list.map(do_math)
  |> int.sum()
  |> int.to_string()
}

fn parse_numbers(a: List(String)) -> List(Result(Int, Nil)) {
  use column <- list.map(a |> list.map(string.to_graphemes) |> list.transpose())
  column |> string.join("") |> string.trim() |> string.reverse() |> int.parse()
}

fn parse_ops(line: String) -> List(String) {
  line |> string.split(" ") |> list.filter(fn(a) { a != "" })
}

fn do_math(value: #(List(Int), String)) -> Int {
  case value {
    #([single], "*") -> single
    #(numbers, "*") -> numbers |> list.fold(1, int.multiply)
    #(numbers, "+") -> numbers |> int.sum()
    _ -> 0
  }
}
