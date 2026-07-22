% Parte 1:
% Punto 1: La gente
% habitante(Nombre, DondeVive, Nacimiento, Raza).
habitante(denken, auberst, 1290, humano).
habitante(voll, ende, 1200, enano).
habitante(serie, weise, 500, elfo).
habitante(fern, weise, 1370, humano).
habitante(stark, riegel, 1368, humano).
habitante(lawine, auberst, 1372, humano).
habitante(kanne, weise, 1365, humano).
habitante(wirbel, klares, 1350, humano).
habitante(lernen, auberst, 1315, humano).
habitante(frieren, weise, 100, elfo).
habitante(eisen, riegel, 1150, enano).

esperanzaDeVida(humano, 80).
esperanzaDeVida(enano, 350).

estaVivo(Persona, Anio):-
    habitante(Persona, _, Nacimiento , elfo),
    Anio >= Nacimiento.

estaVivo(Persona, Anio) :-
    habitante(Persona, _, Nacimiento, Raza),
    Raza \= elfo,
    esperanzaDeVida(Raza, Esperanza),
    Anio >= Nacimiento,
    Anio =< Nacimiento + Esperanza.
    



:- begin_tests(tpIntegrador, []).
    test("Una persona esta viva si ya nacio y no supero su esperanza de vida") :-
        estaVivo(kanne, 1370).

    test("Una persona no esta viva en un anio anterior a su nacimiento") :-
        not(estaVivo(kanne, 1300)).

    test("Una persona no esta viva si ya supero su esperanza de vida") :-
        not(estaVivo(kanne, 2000)).

    test("Una persona esta viva hasta el ultimo anio de su esperanza de vida inclusive") :-
        estaVivo(voll, 1550).

    test("Una persona ya no esta viva al superar su esperanza de vida") :-
        not(estaVivo(voll, 1551)).

    test("Un elfo sigue vivo sin importar cuantos anios pasen desde su nacimiento", nondet) :-
        estaVivo(serie, 5000).
:- end_tests(tpIntegrador).
