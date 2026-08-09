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

estaVivo(Persona, Anio) :-
    habitante(Persona, _, Nacimiento, _),
    Anio >= Nacimiento,
    not(murio(Persona, Anio)).

murio(Persona, Anio) :-
    habitante(Persona, _, Nacimiento, Raza),
    esperanzaDeVida(Raza, Esperanza),
    Anio > Nacimiento + Esperanza.

% Punto 2
% conoceHazana(Persona, AnioEnQueLaConocio, Medio, Hazana).
% hazana(Nombre, [Integrantes], Lugar).
conoceHazana(wirbel, 1390, presencio, hazana(rescatarHermana, [stark, fern], klares)).
conoceHazana(frieren, 1390, presencio, hazana(rescatarHermana, [stark, fern], klares)).
conoceHazana(lawine, 1393, cancion, hazana(destruirAura, [frieren], weise)).
conoceHazana(voll, 1400, libro(50), hazana(destruirAura, [denken], auberst)).
conoceHazana(serie, 1335, libro(100), hazana(destruirReyDemonio, [frieren, himmel, heiter, eisen], ende)).
conoceHazana(kanne, 1375, presencio, hazana(recuperarGato, [himmel, frieren], weise)).

conoceHazana(Persona, AnioAdquisicion, Medio, Hazana) :-
    habitante(Persona, Pueblo, AnioNacimiento, _),
    conmemora(Pueblo, Hazana, Medio),
    anioInicioConmemoracion(Medio, AnioInicio),
    AnioAdquisicion is max(AnioInicio, AnioNacimiento).

% Modifico "conoceHazana(Persona, AnioAdquisicion, Medio, Hazana)" por 
% "conoceHazana(Persona, AnioAdquisicion, Medio, hazana(Hazana, _, _))" para que no haya conflicto con el predicado pasoAlOlvido/2
esRecordada(Hazana, Persona, AnioConsulta) :-
    conoceHazana(Persona, AnioAdquisicion, Medio, hazana(Hazana, _, _)),
    AnioConsulta >= AnioAdquisicion,
    estaVivo(Persona, AnioConsulta),
    recuerdoVigente(Medio, Persona, AnioAdquisicion, AnioConsulta).

recuerdoVigente(presencio, _, _, _).
recuerdoVigente(cancion, _, AnioAdquisicion, AnioConsulta) :-
    AnioConsulta =< AnioAdquisicion + 15.
recuerdoVigente(libro(Paginas), _, AnioAdquisicion, AnioConsulta) :-
    AnioConsulta =< AnioAdquisicion + Paginas.
recuerdoVigente(diaFestivo(_), _, _, _) .
recuerdoVigente(Estatua, _, _, AnioConsulta) :-
    Estatua = estatua(_, _, _, _), 
    estatuaEnBuenEstado(Estatua, AnioConsulta).
% b)
estaCorroborada(Hazana):-
    conoceHazana(_, _, _, hazana(Hazana, _, _)),
    not(tieneVersionesDistintas(Hazana)).

tieneVersionesDistintas(Hazana):-
    conoceHazana(_, _, _, hazana(Hazana, Integrantes1, Lugar1)),
    conoceHazana(_, _, _, hazana(Hazana, Integrantes2, Lugar2)),
    Lugar1 \= Lugar2,
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

%3.b

anioInicioConmemoracion(diaFestivo(Anio), Anio).
anioInicioConmemoracion(estatua(_, _, Anio, _), Anio).

estatuaEnBuenEstado(estatua(marmol, _, _, Mantenimientos), AnioConsulta) :-
    member(AnioMantenimiento, Mantenimientos),
    AnioMantenimiento =< AnioConsulta.
estatuaEnBuenEstado(estatua(marmol, _, AnioConstruido, _), AnioConsulta) :-
    Edad is AnioConsulta - AnioConstruido,
    Edad =< 30.
estatuaEnBuenEstado(estatua(bronce, _, _, Mantenimientos), AnioConsulta) :-
    member(AnioMantenimiento, Mantenimientos),
    AnioMantenimiento =< AnioConsulta.
estatuaEnBuenEstado(estatua(bronce, _, AnioConstruido, _), AnioConsulta) :-
    Edad is AnioConsulta - AnioConstruido,
    Edad =< 15.

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

    test("Una persona sin limite de esperanza de vida sigue viva sin importar cuantos anios pasen desde su nacimiento", nondet) :-
        estaVivo(serie, 5000).

    test("Una persona no recuerda una hazana en un anio previo a haberla conocido") :-
        not(esRecordada(destruirAura, lawine, 1380)).

    test("Una persona recuerda una hazana conocida por una cancion mientras no hayan pasado mas de 15 anios", nondet) :-
        esRecordada(destruirAura, lawine, 1400).

    test("Una persona ya no recuerda una hazana conocida por una cancion si pasaron mas de 15 anios") :-
        not(esRecordada(destruirAura, lawine, 1410)).

    test("Una persona recuerda una hazana conocida por un libro mientras los anios transcurridos no superen su cantidad de paginas", nondet) :-
        esRecordada(destruirAura, voll, 1450).

    test("Una persona ya no recuerda una hazana conocida por un libro si los anios transcurridos superan su cantidad de paginas") :-
        not(esRecordada(destruirAura, voll, 1460)).

    test("Una persona recuerda una hazana que presencio mientras siga con vida", nondet) :-
        esRecordada(rescatarHermana, wirbel, 1430).

    test("Una persona ya no recuerda una hazana que presencio si ya supero su esperanza de vida") :-
        not(esRecordada(rescatarHermana, wirbel, 1440)).

    test("Una hazana esta corroborada si todas las personas que la conocen coinciden en sus detalles (solo existe una version)", nondet) :-
        estaCorroborada(rescatarHermana).

    test("Una hazana no esta corroborada si existen versiones de la misma con diferentes heroes o lugares") :-
        not(estaCorroborada(destruirAura)).

    test("Una hazana pasa al olvido en un anio si ya nadie la recuerda", nondet) :-
        pasoAlOlvido(destruirAura, 1460).

    test("Una hazana no pasa al olvido en un anio si al menos una persona aun la recuerda") :-
        not(pasoAlOlvido(destruirAura, 1440)).
    
    test("Una persona recuerda una hazana si en su pueblo hay una estatua en buen estado que la conmemora", nondet) :-
        esRecordada(destruirReyDemonio, lawine, 1400).

    test("Una persona no recuerda una hazana si la estatua de su pueblo ya no se encuentra en buen estado") :-
        not(esRecordada(destruirReyDemonio, lawine, 1390)).

    test("Una persona recuerda una hazana si en su pueblo se conmemora con un dia festivo", nondet) :-
        esRecordada(destruirReyDemonio, fern, 1400).
:- end_tests(tpIntegrador).
