import gleam/dict
import gleam/int
import gleam/list
import gleam/string
import util/grid.{type Grid}
import util/testing.{TestCase, check}

pub fn main() {
  [
    TestCase("input/day_04/test_01.txt", "13"),
    TestCase("input/day_04/input.txt", "1411"),
  ]
  |> check(solution)
}

fn solution(input: String) -> String {
  let warehouse =
    input
    |> string.split("\n")
    |> list.map(string.to_graphemes)
    |> grid.from_lists()

  warehouse
  |> dict.filter(fn(p, v) { reachable(warehouse, p, v) })
  |> dict.size()
  |> int.to_string()
}

fn reachable(warehouse: Grid(String), p: grid.Point, v: String) -> Bool {
  case v {
    "@" -> {
      warehouse
      |> grid.neighbors_box(p)
      |> dict.filter(fn(_, val) { val == "@" })
      |> dict.size
      < 4
    }
    _ -> False
  }
}
