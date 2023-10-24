generate_mx(0-_, _, Cnt, MxCount, []) :-
    MxCount is Cnt.

generate_mx(N-M, Tp, Cnt, MxCount, Mx) :-
    N > 0,
    N1 is N - 1,
    generate_row(N-M, Tp, 0, RowCnt, Row),
    NewC = Cnt + RowCnt,
    generate_mx(N1-M, Tp, NewC, MxCount, RestMx),
    append(RestMx, [Row], Mx).

generate_row(_-0, _, Cnt, RowCnt, []) :-
    RowCnt is Cnt.

generate_row(N-M, Tp, Cnt, RowCnt, Mx) :-
    M > 0,
    M1 is M - 1,
    coord_in_list(N-M, Tp, CellValue),
    NewCnt is Cnt + CellValue,
    generate_row(N-M1, Tp, NewCnt, RowCnt, RestRow),
    append(RestRow, [CellValue], Mx).

coord_in_list(X-Y, Tp, CellValue) :-
    (member(X-Y, Tp) -> CellValue = 1; CellValue = 0).

coord_in_list(_, _, _, 0).

calc_tents([], [], []).

calc_tents([X-Y | RestFs], [S | RestSs], [NewX-NewY | RestMx]) :-
    update_coordinates(X, Y, S, NewX, NewY),
    calc_tents(RestFs, RestSs, RestMx).

update_coordinates(X, Y, w, X, NewY) :- NewY is Y - 1.
update_coordinates(X, Y, n, NewX, Y) :- NewX is X - 1.
update_coordinates(X, Y, e, X, NewY) :- NewY is Y + 1.
update_coordinates(X, Y, s, NewX, Y) :- NewX is X + 1.

list_length([],0).
list_length([_|TAIL],N) :-
    list_length(TAIL,N1), N is N1 + 1.

satrak_mx(N-M, Fs, Ss, Mx) :-
    calc_tents(Fs, Ss, Tp),
    list_length(Tp, Len),
    generate_mx(N-M, Tp, 0, Cnt, Mx),
    Len = Cnt,
    !.