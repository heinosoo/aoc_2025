import gleam/int
import gleam/list
import gleam/regexp
import gleam/result
import gleam/string
import util/testing.{TestCase, check}

pub fn main() {
  [
    TestCase("input/day_02/test_1.txt", "1227775554"),
    TestCase("input/day_02/input.txt", "34826702005"),
  ]
  |> check(solution)
}

pub fn solution(input: String) -> String {
  let assert Ok(re) = regexp.from_string("^(.+)\\1$")

  input
  |> string.split("\n")
  |> string.join("")
  |> string.split(",")
  |> list.flat_map(fn(range_string) {
    range_string
    |> string.split_once("-")
    |> result.try(fn(split) {
      use a <- result.try(int.parse(split.0))
      use b <- result.try(int.parse(split.1))
      list.range(a, b)
      |> list.filter(fn(id) { id |> int.to_string() |> regexp.check(re, _) })
      |> Ok
    })
    |> result.unwrap([])
  })
  |> int.sum()
  |> int.to_string()
}
