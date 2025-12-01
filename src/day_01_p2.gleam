import gleam/int
import gleam/list
import gleam/result
import gleam/string
import util/testing.{TestCase, check}

pub fn main() {
  [
    TestCase("input/day_01/test_1.txt", "6"),
    TestCase("input/day_01/input.txt", "6932"),
  ]
  |> check(solution)
}

type State {
  State(pos: Int, clicks: Int)
}

pub fn solution(input: String) -> String {
  let final_state =
    input
    |> string.split("\n")
    |> list.map(parse_line)
    |> result.values
    |> list.fold(State(50, 0), rotate)

  final_state.clicks |> int.to_string
}

fn rotate(state: State, rotation: Int) -> State {
  let new_pos = { { state.pos + rotation } % 100 + 100 } % 100
  let next_click = case rotation < 0 {
    True -> { state.pos - 100 } % 100
    False -> state.pos
  }

  State(new_pos, state.clicks + int.absolute_value(next_click + rotation) / 100)
}

fn parse_line(line: String) -> Result(Int, Nil) {
  line |> string.replace("L", "-") |> string.replace("R", "") |> int.parse
}
