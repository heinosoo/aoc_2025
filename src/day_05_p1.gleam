import gleam/int
import gleam/list
import gleam/result
import gleam/string
import util/testing.{TestCase, check}

pub fn main() {
  [
    TestCase("input/day_05/test_01.txt", "3"),
    TestCase("input/day_05/input.txt", "517"),
  ]
  |> check(solution)
}

fn solution(input: String) -> String {
  let assert Ok(#(ranges, ingredients)) = input |> string.split_once("\n\n")

  let ingredients =
    ingredients |> string.split("\n") |> list.map(int.parse) |> result.values()

  let total = list.length(ingredients)

  ranges
  |> string.split("\n")
  |> list.fold(ingredients, remove_spoiled)
  |> list.length()
  |> int.subtract(total, _)
  |> int.to_string()
}

fn remove_spoiled(ingredients: List(Int), range: String) -> List(Int) {
  ingredients |> try_to_remove_spoiled(range) |> result.unwrap(ingredients)
}

fn try_to_remove_spoiled(
  ingredients: List(Int),
  range: String,
) -> Result(List(Int), Nil) {
  use #(min, max) <- result.try(range |> string.split_once("-"))
  use min <- result.try(int.parse(min))
  use max <- result.try(int.parse(max))
  ingredients |> list.filter(fn(n) { n < min || max < n }) |> Ok
}
