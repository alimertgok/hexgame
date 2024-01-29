% Hex Game
%hex board representation as a list of lists
initial_board([
    [empty, empty, empty, empty, empty],
    [empty, empty, empty, empty, empty],
    [empty, empty, empty, empty, empty],
    [empty, empty, empty, empty, empty],
    [empty, empty, empty, empty, empty]
]).
% display the board on standard output
display_board(Board) :-
    write('    A  B  C  D  E\n'),
    display_rows(Board, 1),
    write('    A  B  C  D  E\n').

display_rows([], _) :- nl.
display_rows([Row|Rows], N) :-
    write(N),
    display_cells(Row),
    write(' '),
    write(N),
    nl,
    N1 is N+1,
    display_rows(Rows, N1).

display_cells([]).
display_cells([Cell|Cells]) :-
    write(' '),
    write_cell(Cell),
    display_cells(Cells).

write_cell(empty) :- write(' . ').
write_cell(1) :- write('X').
write_cell(2) :- write('O').


prompt_move(Player, Row, Column) :-
    write('Player '),
    write(Player),
    write(' (row/column): '),
    read(Row/ColumnAtom),
    upcase_atom(ColumnAtom, ColumnAtomUpper),
    atom_codes(ColumnAtomUpper, [ColumnCode]),
    Column is ColumnCode - 64.  % Convert column letter to integer representation


% Make a move on the Hex board
make_move(Board, Row, Column, Player, NewBoard) :-
    nth1(Row, Board, OldRow),
    write('OldRow = '), writeln(OldRow),  %%%%%%%%%%
    replace(Column, OldRow, Player, NewRow),
    write('NewRow = '), writeln(NewRow),  %%%%%%%%%%
    replace(Row, Board, NewRow, NewBoard),
    write('NewBoard = '), writeln(NewBoard).  %%%%%%%%%%


% Replace an element at a given index in a list
replace(1, [_|T], X, [X|T]).
replace(N, [H|T], X, [H|R]) :-
    N > 1,
    N1 is N - 1,
    replace(N1, T, X, R).

% Check if a move is valid on the given board
valid_move(Row, Column, Board) :-
    nth1(Row, Board, RowList),
    nth1(Column, RowList, empty).

% Check if the game is won by a player
game_won(Player, Board) :-
    (horizontal_win(Player, Board); vertical_win(Player, Board)).

% Check for horizontal win
horizontal_win(Player, Board) :-
    member(Row, Board),
    sublist(Row, [Player, Player, Player, Player, Player]).

% Check for vertical win
vertical_win(Player, Board) :-
    transpose(Board, Transposed),
    horizontal_win(Player, Transposed).

% Transpose a matrix
transpose([], []).
transpose([[]|_], []).
transpose(Matrix, [Row|Rows]) :-
    transpose_row(Matrix, Row, RestMatrix),
    transpose(RestMatrix, Rows).

transpose_row([], [], []).
transpose_row([[X|Xs]|Matrix], [X|Row], [Xs|RestMatrix]) :-
    transpose_row(Matrix, Row, RestMatrix).
%?- transpose([[1, 2, 3], [4, 5, 6], [7, 8, 9]], Transposed). Transposed = [[1, 4, 7], [2, 5, 8], [3, 6, 9]].

% Check if a sublist is present in a list
sublist(Sublist, List) :-
    append(_, Rest, List),
    append(Sublist, _, Rest).

% Main game loop
play_hex(Board, Player) :-
    display_board(Board),
    prompt_move(Player, Row, Column),
    write('Row = '), write(Row), write(', Col = '), write(Column), nl, %%%%%%%%%%
    valid_move(Row, Column, Board),
    writeln('Valid move OK'),  %%%%%%%%%%
    make_move(Board, Row, Column, Player, NewBoard),

    (   game_won(Player, NewBoard) -> write('Player '), write(Player), write(' wins!');
        next_player(Player, NextPlayer),
        play_hex(NewBoard, NextPlayer)).

% Determine the next player
next_player(1, 2).
next_player(2, 1).

% Entry point of the game
hex_game :-
    initial_board(Board),
    write('Welcome to the Prolog Hex Game!'), nl,
    play_hex(Board, 1).

