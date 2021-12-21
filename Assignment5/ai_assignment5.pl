found(H):-write('You can take '), write(H),write('.'),nl.

/*
   defining pre requisites for certain courses:
   core cse.
   core ece.
   csai courses.
*/

/* assuming the course list to be restricted as below : */

courses(data_structures_algorithms).
courses(introduction_programming).
courses(computer_organization).
courses(digital_circuits).
courses(advanced_programming).
courses(dbms).
courses(analysis_design_algorithms).
courses(operating_systems).
courses(computer_networks).
courses(modern_algorithm_design).
courses(integrated_electronics).
courses(basic_electronics).
courses(linear_algebra).
courses(advanced_machine_learning).
courses(natural_language_processing).
courses(computer_vision).
courses(deep_learning).
courses(advanced_machine_learning).
courses(machine_learning).
courses(artificial_intelligence).
courses(vlsi).
courses(wireless_signals).
courses(eld).
courses(advanced_eld).
courses(signal_systems).

/*branch wise defining the courses, considering only 3 branches other wise the knowledge base will only grow else functioning is same */
branch_wise(cse,[data_structures_algorithms, introduction_programming, computer_organization, advanced_programming, dbms, analysis_design_algorithms, operating_systems, computer_networks,modern_algorithm_design]).
branch_wise(ece,[digital_circuits,integrated_electronics,basic_electronics,signal_systems,advanced_eld,eld,wireless_signals,vlsi]).
branch_wise(csai,[advanced_machine_learning,natural_language_processing,computer_vision,deep_learning,machine_learning,artificial_intelligence]).

/* cse courses */
prereq(data_structures_algorithms,introduction_programming).
prereq(computer_organization,digital_circuits).
prereq(advanced_programming,data_structures_algorithms).
prereq(dbms,data_structures_algorithms).
prereq(analysis_design_algorithms,data_structures_algorithms).
prereq(operating_systems,data_structures_algorithms).
prereq(computer_networks,operating_systems).
prereq(computer_networks,analysis_design_algorithms).
prereq(modern_algorithm_design,analysis_design_algorithms).

/* ece courses */
prereq(integrated_electronics,digital_circuits).
prereq(integrated_electronics,basic_electronics).
prereq(signal_systems,linear_algebra).
prereq(advanced_eld,digital_circuits).
prereq(advanced_eld,eld).
prereq(eld,basic_electronics).
prereq(wireless_signals,signal_systems).
prereq(vlsi,digital_circuits).
prereq(vlsi,eld).

/* cs and ai courses */

prereq(artificial_intelligence,introduction_programming).
prereq(machine_learning,linear_algebra).
prereq(machine_learning,introduction_programming).
prereq(advanced_machine_learning,machine_learning).
prereq(deep_learning,machine_learning).
prereq(computer_vision,linear_algebra).
prereq(natural_language_processing,analysis_design_algorithms).
prereq(natural_language_processing,linear_algebra).

/* either A is directly prerequisite of B(as given in fact base), else for example if B is prerequisite of A, and C is pre requisite of B, then C is pre requisite of A */

is_prereq(A,B):-prereq(A,B).
is_prereq(A,B):-prereq(A,C),is_prereq(C,B).


/* defining some difficult courses which can only be taken if either if btp is done or cgpa is high (greater than 8.5) */

list_length([],0).
list_length([_|T],L):- list_length(T,L1), L is L1+1.


/* the below functions are deciding which course is difficult and which is easy
   the courses having > 2 prerequisites are difficult, =2 pre reqs are
   medium and <2 pre reqs are easy.
   the function is using prolog features such as cuts, recursion, lists
   etc.

*/

get_difficult(Branch):-  branch_wise(Branch,Courses), find_difficult(Courses).
find_difficult([]).
find_difficult([H|T]):- difficult(H),find_difficult(T) .
difficult(H):-findall(X,is_prereq(H,X),R1),
                    sort(R1,R),
                    list_length(R,Len),
                    Len>2,
                    found(H),
                    !.
difficult(_).

get_medium(Branch):-  branch_wise(Branch,Courses), find_medium(Courses).
find_medium([]).
find_medium([H|T]):- medium(H),find_medium(T) .
medium(H):-findall(X,is_prereq(H,X),R1),
                    sort(R1,R),
                    list_length(R,Len),
                    Len=:=2,
                    found(H),
                    !.
medium(_).

get_easy(Branch):-  branch_wise(Branch,Courses), find_easy(Courses).
find_easy([]).
find_easy([H|T]):- easy(H),find_easy(T) .
easy(H):-findall(X,is_prereq(H,X),R1),
                    sort(R1,R),
                    list_length(R,Len),
                    Len<2,
                    found(H),
                    !.
easy(_).


know() :-
    ['C:/Users/Bhavya/ai_assigment5.txt'],interest(X,Y),difficulty_level(X,Y), write('All the best for your future.').


difficulty_level(A,B):- B>=8, get_difficult(A),!.
difficulty_level(A,B):- B>=6, get_medium(A),!.
difficulty_level(A,_):- get_easy(A),!.

