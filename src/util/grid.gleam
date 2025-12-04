import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/pair
import gleam/result
import gleam/string

pub type Point {
  Point(x: Int, y: Int)
}

pub type Grid(t) =
  Dict(Point, t)

pub fn from_lists(from: List(List(t))) -> Grid(t) {
  {
    use inner_list, y <- list.index_map(from)
    use value, x <- list.index_map(inner_list)
    #(Point(x:, y:), value)
  }
  |> list.flatten()
  |> dict.from_list()
}

pub fn new(value: t, from: Point, to: Point) -> Grid(t) {
  { list.map(point_range(from, to), pair.new(_, value)) }
  |> dict.from_list()
}

pub fn get(grid: Grid(t), p: Point) -> t {
  let assert Ok(value) = dict.get(grid, p)
  value
}

pub fn set(grid: Grid(t), point: Point, value: t) -> Grid(t) {
  dict.insert(grid, point, value)
}

pub fn point_range(a: Point, b: Point) -> List(Point) {
  use x <- list.flat_map(list.range(a.x, b.x))
  use y <- list.map(list.range(a.y, b.y))
  Point(x, y)
}

pub fn neighbors_plus(grid: Grid(t), point: Point) -> Grid(t) {
  [
    Point(point.x - 1, point.y),
    Point(point.x + 1, point.y),
    Point(point.x, point.y - 1),
    Point(point.x, point.y + 1),
  ]
  |> dict.take(grid, _)
}

pub fn neighbors_box(grid: Grid(t), point: Point) -> Grid(t) {
  [
    Point(point.x - 1, point.y - 1),
    Point(point.x - 1, point.y),
    Point(point.x - 1, point.y + 1),
    Point(point.x, point.y - 1),
    Point(point.x, point.y + 1),
    Point(point.x + 1, point.y - 1),
    Point(point.x + 1, point.y),
    Point(point.x + 1, point.y + 1),
  ]
  |> dict.take(grid, _)
}

pub fn print(grid: Grid(String)) {
  let assert Ok(first) = dict.keys(grid) |> list.first
  let #(p1, p2) = {
    use #(a, b), c <- list.fold(dict.keys(grid), #(first, first))
    #(
      Point(
        a.x |> int.min(b.x) |> int.min(c.x),
        a.y |> int.min(b.y) |> int.min(c.y),
      ),
      Point(
        a.x |> int.max(b.x) |> int.max(c.x),
        a.y |> int.max(b.y) |> int.max(c.y),
      ),
    )
  }

  {
    use y <- list.map(list.range(p1.y, p2.y))
    use x <- list.map(list.range(p1.x, p2.x))
    dict.get(grid, Point(x, y)) |> result.unwrap(" ")
  }
  |> list.map(string.concat)
  |> list.each(io.println)

  grid
}
