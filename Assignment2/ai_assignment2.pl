/* heuristic is minimum distance between any 2 given cities hence it is both admissable and consistent
*/

show_path([A]):-write(A), nl.
show_path([H|T]):-write(H),write(' to '),show_path(T).

/*
 funtion to import dynamic facts from csv files
*/

get_lengths:- csv_read_file('D:/study/Sem Wise/sem5/AI/Assignments/Assignment2/modified_distance_file.csv', Data, [functor(leng)]), maplist(assert, Data).
get_heuristics:- csv_read_file('D:/study/Sem Wise/sem5/AI/Assignments/Assignment2/heuristic_file.csv', Data, [functor(heuristic)]), maplist(assert, Data).
get_data():- get_lengths, get_heuristics.

length(Start,End,Length):-leng(Start,End,Length).
length(Start,End,Length):-leng(End,Start,Length).
/*
 function to find next city for dfs and for best first respectively
 */
find_minimum(Present,Next,Length):-aggregate(min(Length,Next), heuristic(Present,Next,Length),min(_,Next)).
find_best(Present,Next,Path,Length):-find_minimum(Present,Next,_),length(Present,Next,Length),not(member(Next,Path)).
find_next(Present,Next,Visited,Length):-length(Present,Next,Length), not(member(Next,Visited)).
/*
 implementation of dfs
 */
depth_first_search(Start, Start,Path, [Start], Leng) :- write('Path taken is: '),nl, reverse(Path, Final_Path), show_path(Final_Path),nl,write('Length of path is: '),write(Leng).

depth_first_search(Start, End, Done, [Start|Path], L1) :- find_next(Start, Next_node,Done, L2), L is L1+L2, depth_first_search(Next_node, End, [Next_node|Done], Path, L).
/* implementation of best first search */

best_first_search(Start, Start,Path, [Start], Leng) :- write('Path taken is: '),nl, reverse(Path, Final_Path), show_path(Final_Path),nl,write('Length of path is: '),write(Leng).
best_first_search(Start, End, Done, [Start|Path], L1) :- find_best(Start, Next,Done, L2), L is L1+L2, best_first_search(Next, End, [Next|Done], Path, L).

/* for input output */
input():- write("Enter the first city "), nl, read(A),
          write("Enter the second city "), nl, read(B),
          write("Enter type of search, 1 for depth first and 2 for best first "), nl, read(C),get_ans(A,B,C) .

get_ans(A,B,1):- depth_first_search(A,B,[A],_,0),nl.
get_ans(A,B,2):- best_first_search(A,B,[A],_,0),nl.

