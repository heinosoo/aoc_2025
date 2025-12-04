import gleam/dict
import gleam/int
import gleam/list
import gleam/string
import util/grid.{type Grid}
import util/testing.{TestCase, check}

pub fn main() {
  [
    TestCase("input/day_04/test_01.txt", "43"),
    TestCase("input/day_04/input.txt", "8557"),
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
  |> remove_rolls()
  |> dict.filter(fn(_, v) { v == "x" })
  |> dict.size()
  |> int.to_string()
}

fn remove_rolls(warehouse: Grid(String)) -> Grid(String) {
  let new_warehouse = {
    use p, v <- dict.map_values(warehouse)
    case reachable(warehouse, p, v) {
      False -> v
      True -> "x"
    }
  }

  case new_warehouse == warehouse {
    False -> remove_rolls(new_warehouse)
    True -> new_warehouse
  }
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
