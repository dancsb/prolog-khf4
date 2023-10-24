% :- type parcMutató ==   int-int.          % egy parcella helyét meghatározó egészszám-pár
% :- type fák        ==   list(parcMutató). % a fák helyeit tartalmazó lista
% :- type irány    --->   n                 % észak 
%                       ; e                 % kelet 
%                       ; s                 % dél   
%                       ; w.                % nyugat
% :- type sHelyek    ==   list(irany).      % a fákhoz tartozó sátrak irányát megadó lista
% :- type bool       ==   int               % csak 0 vagy 1 lehet
% :- type boolMx     ==   list(list(bool)). % a sátrak helyét leíró 0-1 mátrix

% :- pred satrak_mx(parcMutató::in,         % NM
%                   fák::in,                % Fs
%                   sHelyek::in,            % Ss
%                   boolMx::out).           % Mx

% Elfogytaka a sorok
generate_mx(0-_, _, Cnt, MxCnt, []) :-
    MxCnt is Cnt.

% Mátrix sorainak előállítása
generate_mx(N-M, Tp, Cnt, MxCnt, Mx) :-
    N > 0,
    N1 is N - 1,
    generate_row(N-M, Tp, 0, RowCnt, Row),
    NewC = Cnt + RowCnt,
    generate_mx(N1-M, Tp, NewC, MxCnt, RestMx),
    append(RestMx, [Row], Mx).

% Elfogytaka az oszlopok
generate_row(_-0, _, Cnt, RowCnt, []) :-
    RowCnt is Cnt.

% Mátrix oszlopainak előállítása
generate_row(N-M, Tp, Cnt, RowCnt, Mx) :-
    M > 0,
    M1 is M - 1,
    coord_in_list(N-M, Tp, CellValue),
    NewCnt is Cnt + CellValue,
    generate_row(N-M1, Tp, NewCnt, RowCnt, RestRow),
    append(RestRow, [CellValue], Mx).

% Cella érték meghatározása
coord_in_list(X-Y, Tp, CellValue) :-
    (member(X-Y, Tp) -> CellValue = 1; CellValue = 0).

% Elfogytaka a fák
calc_tents([], [], []).

% Sátrak meghatározása rekurzívan a fák alapján
calc_tents([X-Y | RestFs], [S | RestSs], [NewX-NewY | RestMx]) :-
    update_coordinates(X, Y, S, NewX, NewY),
    calc_tents(RestFs, RestSs, RestMx).

update_coordinates(X, Y, w, X, NewY) :- NewY is Y - 1. % Nyugat
update_coordinates(X, Y, n, NewX, Y) :- NewX is X - 1. % Észak
update_coordinates(X, Y, e, X, NewY) :- NewY is Y + 1. % Kelet
update_coordinates(X, Y, s, NewX, Y) :- NewX is X + 1. % Dél

% Lista hosszának meghatározása
list_length([], 0).

list_length([_ | Rest], N) :-
    list_length(Rest, N1),
    N is N1 + 1.

satrak_mx(N-M, Fs, Ss, Mx) :-
    calc_tents(Fs, Ss, Tp), % Sátorpozíciók meghatározása
    list_length(Tp, Len), % Szükséges sátrak megszámlálása
    generate_mx(N-M, Tp, 0, Cnt, Mx), % Mátrix generálása és lerakott sátrak megszámlálása
    Len = Cnt, % Szükséges sátrak számának összehasonlítása a lerakottakéval
    !. % cut