generate_mx(0-_, _, []).

generate_mx(N-M, Tp, Mx) :-
    N > 0,
    N1 is N - 1,
    generate_row(N-M, Tp, Row),
    generate_mx(N1-M, Tp, RestMx),
    append(RestMx, [Row], Mx).

generate_row(_-0, _, []).
generate_row(N-M, Tp, Mx) :-
    M > 0,
    M1 is M - 1,
    coord_in_list(N-M, Tp, CellValue),
    generate_row(N-M1, Tp, RestRow),
    append(RestRow, [CellValue], Mx).

coord_in_list(X-Y, Tp, CellValue) :-
    member(X-Y, Tp),
    CellValue is 1.

coord_in_list(_, _, 0).

calc_tents([], [], _, []).

calc_tents([X-Y | RestFs], [S | RestSs], Seen, [NewX-NewY | RestMx]) :-
    update_coordinates(X, Y, S, NewX, NewY),
    \+ member(NewX-NewY, Seen),
    calc_tents(RestFs, RestSs, [NewX-NewY | Seen], RestMx).

update_coordinates(X, Y, w, X, NewY) :- NewY is Y - 1.
update_coordinates(X, Y, n, NewX, Y) :- NewX is X - 1.
update_coordinates(X, Y, e, X, NewY) :- NewY is Y + 1.
update_coordinates(X, Y, s, NewX, Y) :- NewX is X + 1.

satrak_mx(N-M, Fs, Ss, Mx) :-
    calc_tents(Fs, Ss, [], Tp),
    generate_mx(N-M, Tp, Mx),
    !.