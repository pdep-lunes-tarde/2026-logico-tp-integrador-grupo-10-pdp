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
    



% Punto 2
% conoceHazana(Persona, AnioEnQueLaConocio, Medio, Hazana).
% hazana(Nombre, [Integrantes], Lugar).
conoceHazana(wirbel, 1390, presencio, hazana(rescatarHermana, [stark, fern], klares)).
conoceHazana(frieren, 1390, presencio, hazana(rescatarHermana, [stark, fern], klares)).

conoceHazana(lawine, 1393, cancion, hazana(destruirAura, [frieren], weise)).
conoceHazana(voll, 1400, libro(50), hazana(destruirAura, [denken], auberst)).

conoceHazana(serie, 1335, libro(100), hazana(destruirReyDemonio, [frieren, himmel, heiter, eisen], ende)).
conoceHazana(kanne, 1375, presencio, hazana(recuperarGato, [himmel, frieren], weise)).

% Modifico "conoceHazana(Persona, AnioAdquisicion, Medio, Hazana)" por 
% "conoceHazana(Persona, AnioAdquisicion, Medio, hazana(Hazana, _, _))" para que no haya conflicto con el predicado pasoAlOlvido/2
esRecordada(Hazana, Persona, AnioConsulta) :-
    conoceHazana(Persona, AnioAdquisicion, Medio, hazana(Hazana, _, _)),
    AnioConsulta >= AnioAdquisicion,
    recuerdoVigente(Medio, Persona, AnioAdquisicion, AnioConsulta).

recuerdoVigente(presencio, Persona, _, AnioConsulta) :-
    estaVivo(Persona, AnioConsulta).

recuerdoVigente(cancion, _, AnioAdquisicion, AnioConsulta) :-
    AnioConsulta =< AnioAdquisicion + 15.

recuerdoVigente(libro(Paginas), _, AnioAdquisicion, AnioConsulta) :-
    AnioConsulta =< AnioAdquisicion + Paginas.

% b)
estaCorroborada(Hazana):-
    conoceHazana(_, _, _, hazana(Hazana, _, _)),
    not(tieneVersionesDistintas(Hazana)).

tieneVersionesDistintas(Hazana):-
    conoceHazana(_, _, _, hazana(Hazana, _, Lugar1)),
    conoceHazana(_, _, _, hazana(Hazana, _, Lugar2)),
    Lugar1 \= Lugar2.

tieneVersionesDistintas(Hazana):-
    conoceHazana(_, _, _, hazana(Hazana, Integrantes1, _)),
    conoceHazana(_, _, _, hazana(Hazana, Integrantes2, _)),
    Integrantes1 \= Integrantes2.

% c) Queremos saber si en cierto año una hazaña pasó al olvido, lo cuál ocurre si ya nadie la recuerda en ese año.

pasoAlOlvido(Hazana, AnioConsulta):-
    conoceHazana(_, _, _, hazana(Hazana, _, _)),
    not(esRecordada(Hazana, _, AnioConsulta)).

% Punto 3
% conmemora(Pueblo, Hazana, ModoDeConmemorar).
% diaFestivo(AnioQueSeCelebro).
% estatua(Material, NombreDeEstatua, AnioConstruido, [AniosDeMantenimiento]).
conmemora(weise, hazana(destruirReyDemonio, [frieren, himmel, heiter, eisen], ende), diaFestivo(1340)).
conmemora(auberst, hazana(destruirReyDemonio, [frieren, himmel, heiter, eisen], ende), estatua(bronce, equipoDeHeroes, 1370, [1400, 1450])).
conmemora(auberst, hazana(destruirSchlat, [heroeDelSur], ende), estatua(marmol, heroeDelSur, 1340, [1410])).




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
