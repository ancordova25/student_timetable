#const max_cp = 30.
#const min_cp = 18.
#const cost_max_cp = 3.
#const cost_min_cp = 3.

1 {selected(C) : course(C,N,CP,L)}.	

%% Hard Constraints

% H1. Lectures
N { scheduled(C,D,T) : slot(C,K,D,T) } N :- course(C,N,CP,L), selected(C).

% H2. Conflicts
:- scheduled(C,D,T), scheduled(C',D,T), C!=C'.

% H3. WorkDay
coursedays(CD) :- CD = #count{ D : scheduled(C,D,T) }.
:- coursedays(CD), CD > 4.

% H4. Exercise
exercise(C,D,T) :- scheduled(C,D,T), slot(C,K,D,T), K=e, course(C,N,CP,L).
:- exercise(C,D,T), exercise(C,D',T), D != D'.
:- exercise(C,D,T), exercise(C,D,T'), T != T'.

%% Soft Constraints

% sum CP on selected courses
total(S) :- S = #sum{ CP : course(C,N,CP,L), scheduled(C,D,T) }.

% S1. MinimumCP
penalty("minimum_cp",cost_min_cp*(min_cp-S)) :- total(S), S<min_cp.

% S2. MaximumCP
penalty("maximum_cp",cost_min_cp*(S-max_cp)) :- total(S), S>max_cp.

% S3. Windows
penalty("windows",T2-T1+1) :- scheduled(C,D,T1), scheduled(C',D,T2), T2 > T1.

% S4. Language
penalty("language",R) :- R = #count{ C : scheduled(C,D,T), course(C,N,CP,L), L = german }.

total_penalty(TP) :- TP = #sum { P :  penalty(_,P) }.
#minimize { TP : total_penalty(TP) }.

#show scheduled/3.
%#show penalty/2.
