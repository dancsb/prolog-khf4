% Base case: an empty matrix
generate_mx(0-_, []).

% Recursive case: construct a matrix with N rows, each containing M zeros
generate_mx(N-M, Mx) :-
    N > 0,
    N1 is N - 1,
    generate_row(M, Row),
    generate_mx(N1-M, RestMx),
    Mx = [Row | RestMx].

% Predicate to generate a row of M zeros
generate_row(0, []).
generate_row(M, [0 | RestRow]) :-
    M > 0,
    M1 is M - 1,
    generate_row(M1, RestRow).

% Define the base case when both lists are empty.
calc_tents([], [], []).

% Define the recursive case for non-empty lists.
calc_tents([X-Y | RestFs], [S | RestSs], [NewX-NewY | RestMx]) :-
    update_coordinates(X, Y, S, NewX, NewY),  % Update coordinates based on direction
    calc_tents(RestFs, RestSs, RestMx).       % Recur with the remaining elements

% Define predicates for updating coordinates based on direction
update_coordinates(X, Y, w, X, NewY) :- NewY is Y - 1.
update_coordinates(X, Y, n, NewX, Y) :- NewX is X - 1.
update_coordinates(X, Y, e, X, NewY) :- NewY is Y + 1.
update_coordinates(X, Y, s, NewX, Y) :- NewX is X + 1.

satrak_mx(N-M, Fs, Ss, Mx) :-
    generate_mx(N-M, Mx),
    calc_tents(Fs, Ss, Ms),
    write(Ms).