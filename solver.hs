{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use camelCase" #-}
import Data.Char
import Data.List  
import Data.Tuple 
import Data.Maybe

type Board = [[Value]]
type Grid = [[Cell]]
type Pos = (Row,Col)
type Row = Value
type Col = Value
type Value = Int

grid_size, pos_values :: [Value]
grid_size = [0 .. 8]
pos_values = [1 .. 9]

border :: String
border =  "-------------------------------------"

data Cell = Fixed Value | Free [Value]
    deriving (Eq)
instance Show Cell where
    show (Fixed cell) = show cell ++ " | "

is_fixed  :: Cell -> Bool
is_fixed (Fixed _) = True
is_fixed (Free _) = False 

main :: IO()
main = do
    file <- readFile "sudoku.txt"
    let games = string_repr . chunks 10 $ lines file
    writeFile "solved_sudoku.txt" games

-- splitting Text to games -- helper --
chunks :: Int -> [String] -> [[String]]
chunks _ [] = []
chunks n xs =
    let (ys, zs) = splitAt n xs
    in  ys : chunks n zs

-- converting from string to board -- 
-- splitting the # board and board --
-- adding it to the string after being solved
-- and repr correctly -- 
string_repr :: [[String]] -> String
string_repr [] = ""
string_repr (game : games) =
    let  num = head game ++ "\n\n"
         board = string_to_board $ tail game
         solved_game =  grid_repr . solve $ board_to_grid board
    in  num  ++  border ++ "\n" 
        ++  solved_game ++ "\n" 
        ++ string_repr games

grid_repr :: Grid -> String
grid_repr [] = ""
grid_repr (row : grid)= "| " ++ concatMap show row ++ "\n" 
                             ++ border
                             ++ "\n" ++ grid_repr grid

string_to_board :: [String] -> Board
string_to_board = map $ map digitToInt

-- setting values from board to grid.
-- if its 0, find the constraints for that position.
board_to_grid :: Board -> Grid
board_to_grid board =  [ [ if value == 0 then Free (possible_values board (r,c))
                         else Fixed value|
                        (value,c) <-row_values `zip` grid_size]
                        | (row_values,r) <- board `zip` grid_size]

-- all possible values for current position. 
possible_values :: Board -> Pos -> [Value]
possible_values board p@(r,c) = pos_values \\ (row board r ++
                                               col board c ++
                                               block board p)
-- Get possible values from row.
row :: Board -> Row -> [Value]
row board r = board !! r

-- Get possible values from col.
col :: Board -> Col ->[Value]
col board c  = transpose board !! c

-- get possible values from block.
block :: Board -> Pos -> [Value]
block board (r, c) =
                    [value | (r_values, r2) <- board `zip` grid_size,
                    (value, c2) <- r_values `zip` grid_size,
                    same_block (r,c) (r2,c2) ]

-- checking by combination of the positons of the blocks,
-- if it has the same coordinates of blocks return true
same_block :: Pos -> Pos -> Bool
same_block (r,c) (r2,c2) =
    (r `quot` 3, c `quot` 3) == (r2 `quot` 3, c2 `quot` 3)

-- getting the best move from all possible moves,
-- the move with the least possible moves.
get_move :: Grid -> Maybe (Pos,[Value])
get_move grid =
    let pos_values' = [((r,c),  values) | (r_cells,r) <- grid `zip` grid_size,
                     (Free values, c) <- r_cells `zip` grid_size ]
    in if not $ null pos_values' then Just $ minimumBy length' pos_values'
       else Nothing

-- helper to get the minimum length of possible values -- 
length' :: (Pos,[Value]) -> (Pos,[Value]) -> Ordering
length' (_,values) (_,values2) =
            compare (length values) (length values2)

-- making the next move, pruning the grid based on 
-- the new value and returning the new pruned grid
get_next_grid :: Grid -> Pos -> Value -> Grid
get_next_grid grid pos value = [
                                 [prune_cell pos (r,c) pos_values' value |
                                 (pos_values',c) <- r_cells `zip` grid_size]
                                 | (r_cells,r) <- grid `zip` grid_size]

-- check if the cell is fix or it is in the wanted position
-- prune the value from the relavent cells (rows,cols,block).
prune_cell :: Pos -> Pos -> Cell -> Value -> Cell
prune_cell p@(r,c) p2@(r2,c2) pos_values' value
            | is_fixed pos_values' = pos_values'
            | p == p2 =  Fixed value
            | r == r2 || c == c2 = prune pos_values' [value]
            | same_block p p2 = prune pos_values' [value]
            | otherwise = pos_values'

prune :: Cell -> [Value] -> Cell
prune (Free cell) value =  Free $ cell \\ value

-- return the Grid fully solved.
solve :: Grid -> Grid
solve grid =
    let moves = get_move grid
    in maybe grid (uncurry (make_next_move grid)) moves

-- making the next move from the cell 
-- with least possible values .
make_next_move :: Grid -> Pos -> [Value] -> Grid
make_next_move _ _ [] = []
make_next_move grid pos (move : moves) =
    let next_grid = solve $ get_next_grid grid pos move
    in if not $ null next_grid then next_grid
       else make_next_move grid pos moves