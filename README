# Sudoku Solver

This is a Haskell program that solves Sudoku puzzles. It provides functions to read Sudoku puzzles from a file, solve them, and write the solved puzzles to another file. The program uses a backtracking algorithm to find the solution.

## Pragmas

- `{-# OPTIONS_GHC -Wno-incomplete-patterns #-}`: Disables warnings for incomplete patterns in pattern matching.
- `{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}`: Disables warnings for unrecognized pragmas.

## Imports

The program imports the following modules:

- `Data.Char`: Provides functions for working with characters.
- `Data.List`: Provides functions for working with lists.
- `Data.Tuple`: Provides functions for working with tuples.
- `Data.Maybe`: Provides functions for working with optional values (`Maybe` type).

## Types

The program defines several type aliases and a custom data type:

- `type Board = [[Value]]`: Represents a Sudoku board as a 2-dimensional list of `Value`.
- `type Grid = [[Cell]]`: Represents a Sudoku grid as a 2-dimensional list of `Cell`.
- `type Pos = (Row, Col)`: Represents the position of a cell in the grid.
- `type Row = Value`: Represents a row index.
- `type Col = Value`: Represents a column index.
- `type Value = Int`: Represents a cell value.

The custom data type is:

- `data Cell = Fixed Value | Free [Value]`: Represents a Sudoku cell. It can be either a fixed value or a list of possible values. The `Value` type is used for both fixed values and possible values.

## Helper Functions

The program defines several helper functions:

- `is_fixed :: Cell -> Bool`: Checks if a cell is fixed (has a fixed value).
- `chunks :: Int -> [String] -> [[String]]`: Splits a list of strings into chunks of a specified size.
- `string_repr :: [[String]] -> String`: Converts a list of string representations of Sudoku puzzles to a formatted string representation of solved puzzles.
- `grid_repr :: Grid -> String`: Converts a grid to a formatted string representation.
- `string_to_board :: [String] -> Board`: Converts a list of strings to a Sudoku board.
- `board_to_grid :: Board -> Grid`: Converts a Sudoku board to a grid of cells.
- `possible_values :: Board -> Pos -> [Value]`: Determines the possible values for a given position on the board.
- `row :: Board -> Row -> [Value]`: Retrieves the values in a row of the board.
- `col :: Board -> Col -> [Value]`: Retrieves the values in a column of the board.
- `block :: Board -> Pos -> [Value]`: Retrieves the values in a block (3x3 subgrid) of the board.
- `same_block :: Pos -> Pos -> Bool`: Checks if two positions are in the same block.
- `get_move :: Grid -> Maybe (Pos, [Value])`: Determines the next move (cell) with the least number of possible values.
- `length' :: (Pos, [Value]) -> (Pos, [Value]) -> Ordering`: Compares the length of two lists of possible values.
- `get_next_grid :: Grid -> Pos -> Value -> Grid`: Prunes the grid based on the new value and returns the pruned grid.
- `prune_cell :: Pos -> Pos -> Cell -> Value -> Cell`: Prunes a value from the relevant cells based on the position.
- `prune :: Cell -> [Value] -> Cell`: Prunes a list of values from a cell.
- `solve :: Grid -> Grid`: Solves the Sudoku puzzle using a

 backtracking algorithm.
- `make_next_move :: Grid -> Pos -> [Value] -> Grid`: Makes the next move (backtracking) based on the cell with the least possible values.

## I/O Functions

The program defines the `main` function as the entry point of the program. It performs the following tasks:

1. Reads the Sudoku puzzles from a file called "sudoku.txt".
2. Converts the puzzles to a string representation after solving them.
3. Writes the solved puzzles to a file called "solved_sudoku.txt".

## Usage

To use this Sudoku solver, you need to create a file called "sudoku.txt" containing one or more Sudoku puzzles. Each puzzle should be represented as a 9x9 grid, with empty cells represented by zeros. For example:

```
530070000
600195000
098000060
800060003
400803001
700020006
060000280
000419005
000080079

...
```

After running the program, the solved puzzles will be written to the "solved_sudoku.txt" file.

Note: The provided code assumes that the Sudoku puzzles in the input file are valid and solvable.
