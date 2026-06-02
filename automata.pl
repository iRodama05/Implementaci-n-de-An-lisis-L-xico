% --- 1. DEFINICIÓN DE TRANSICIONES ---
% transicion(EstadoActual, Caracter, EstadoSiguiente).

% Rama "Certhas"
transicion(q0, 'C', q1).
transicion(q1, 'e', q2).
transicion(q2, 'r', q3).
transicion(q3, 't', q4).
transicion(q4, 'h', q5).
transicion(q5, 'a', q6).
transicion(q6, 's', qF).

% Rama "Cirth"
transicion(q1, 'i', q8).
transicion(q8, 'r', q9).
transicion(q9, 't', q10).
transicion(q10, 'h', qF).

% Rama "Coirë"
transicion(q1, 'o', q12).
transicion(q12, 'i', q13).
transicion(q13, 'r', q14).
transicion(q14, 'ë', qF).

% Rama "Coranar"
transicion(q12, 'r', q16).
transicion(q16, 'a', q17).
transicion(q17, 'n', q18).
transicion(q18, 'a', q19).
transicion(q19, 'r', qF).

% Rama "Cormallen"
transicion(q16, 'm', q21).
transicion(q21, 'a', q22).
transicion(q22, 'l', q23).
transicion(q23, 'l', q24).
transicion(q24, 'e', q25).
transicion(q25, 'n', qF).

% --- 2. ACEPTACIÓN ---
% Estado unificado final para optimización espacial
acepta(qF).


% --- 3. EVALUACIÓN ---

% Caso base: La lista de caracteres está vacía y estamos en estado de aceptación.
evaluar(Estado, []) :- acepta(Estado).

% Caso recursivo: Consume un caracter, busca la transición válida y avanza.
evaluar(Estado, [Char | Resto]) :-
    transicion(Estado, Char, Siguiente),
    evaluar(Siguiente, Resto).


% --- 4. FUNCIÓN PRINCIPAL ---
% Convierte un string en lista de caracteres e inicia la evaluación en q0.
analizar(Palabra) :-
    string_chars(Palabra, ListaChars),
    (   evaluar(q0, ListaChars)
    ->  format('~w -> yes~n', [Palabra])
    ;   format('~w -> no~n', [Palabra])
    ).


% --- 5. SCRIPT DE PRUEBAS AUTOMATIZADAS ---
test_all :-
    write('--- PRUEBAS DE CASOS POSITIVOS ---'), nl,
    analizar("Certhas"),
    analizar("Cirth"),
    analizar("Coirë"),
    analizar("Coranar"),
    analizar("Cormallen"),
    nl,
    write('--- PRUEBAS DE CASOS NEGATIVOS ---'), nl,
    analizar("Certh"),
    analizar("Cirthas"),
    analizar("coirë"),
    analizar("Cor"),
    analizar("Elrond"),
    analizar("CormallenX"),
    analizar("").
