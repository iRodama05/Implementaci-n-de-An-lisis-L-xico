# Implementación de Análisis Léxico
## Descripción
### Lenguaje Seleccionado:
El lenguaje elegido consiste en un conjunto finito de palabras específicas pertenecientes a las lenguas élficas: Certhas, Cirth, Coirë, Coranar y Cormallen.
Aunque se trata de un conjunto de palabras de un idioma de ficción, este problema nos ayuda a adentrarnos en los fundamentos de las ciencias de la computación. Las reglas que sigue este modelo son las mismas que se utilizan para construir analizadores léxicos (la primera fase de un compilador). En palabras simples, es el mismo proceso que usa una computadora cuando lee el código fuente de un programa y logra identificar cuáles son las "palabras reservadas" (como if, while o for) dentro de todo el texto.

### Técnicas de Modelado y Justificación:
Para modelar la solución y garantizar eficiencia sin ambigüedad computacional, decidí construir un Autómata Finito Determinista (DFA) como núcleo del proyecto, implementado de forma nativa en Prolog, y contrastarlo posteriormente con su equivalente en Expresiones Regulares (RE) en Python.

De acuerdo con Aho et al. (2006) en su obra Compilers: Principles, Techniques, and Tools, los autómatas finitos son los modelos estándar para construir escáneres léxicos por su alta eficiencia. Permiten validar una palabra en tiempo lineal (complejidad $O(n)$); esto significa que la computadora solo necesita leer la palabra una vez, letra por letra.

Como señala Sipser (2012) en Introduction to the Theory of Computation, el DFA tiene una gran ventaja computacional: garantiza que, por cada letra que se lee, solo existe un camino posible a seguir. Esto significa que el programa no tendrá que "adivinar" opciones ni retroceder si se equivoca (evitando el backtracking). El resultado es un código mucho más directo y rápido.

## Modelado de la solución
Para construir la solución, diseñé primero tres Autómatas Finitos Deterministas (DFA) parciales para agrupar lógicamente el vocabulario. Me aseguré de que estos modelos iniciales fueran estrictamente deterministas, sin transiciones vacías y con un solo camino definido por cada símbolo.

El primer autómata parcial (DFA 1) se utiliza para representar las palabras del lenguaje que comparten la raíz "C" seguida de las vocales "e" o "i" (Certhas y Cirth).
![94f7d7d6-442b-4e69-a1a7-722b90b8ab6a](https://github.com/user-attachments/assets/ec1d6b4c-3435-4bf4-b05a-63889a1f3516)

El segundo autómata parcial (DFA 2) se utiliza para representar la palabra que se bifurca directamente hacia la terminación "irë" (Coirë).
![Notes_260323_221527_2](https://github.com/user-attachments/assets/f634e3dd-a7ef-4553-80c8-2027f2c5fe7e)

El tercer autómata parcial (DFA 3) se utiliza para representar las palabras que comparten el prefijo "Cor" (Coranar y Cormallen).
![Notes_260323_221527_3](https://github.com/user-attachments/assets/c0297526-c89c-450a-8bef-8cb2e3d68680)

Posteriormente, se unificaron estos diagramas en un DFA final. Para optimizar este DFA, se aplicó factorización por la izquierda en el diseño, lo que agrupa los prefijos comunes (como la letra 'C' o el segmento 'Cor') para evitar bifurcaciones redundantes. Además, como optimización espacial adicional, todos los caminos convergen en un único estado de aceptación unificado, reduciendo la cantidad total de estados en memoria.

El autómata optimizado resultante (DFA) fue el siguiente:
![Automata](https://github.com/user-attachments/assets/2f26f800-cf53-4c30-b7f6-cc01dac26b69)

Los autómatas presentados son equivalentes a las siguientes expresiones regulares (RE):

NFA 1 -> RE 1: `C(erthas|irth)`

NFA 2 -> RE 2: `Coirë`

NFA 3 -> RE 3: `Cor(anar|mallen)`

DFA Final -> RE Final: `C(erthas|irth|o(irë|r(anar|mallen)))`

## Implementación
El DFA consta de un estado inicial ($q_0$) y un estado de aceptación maestro unificado ($q_F$). Las transiciones aseguran que, por cada carácter leído, exista un único camino.
- **Aceptación ("Coirë"):** El autómata inicia en $q_0$. Al leer `C`, transita a $q_1$. Al leer `o`, transita a $q_{12}$. Sigue la ruta leyendo `i` ($q_{13}$), `r` ($q_{14}$) y finalmente 'ë', llegando a $q_F$. Como la cadena termina y el estado es válido, la palabra es aceptada.
- **Rechazo por Prefijo ("Certh"):** El autómata avanza correctamente desde $q_0$ hasta $q_4$ leyendo `C-e-r-t-h`. Sin embargo, la cadena de entrada termina en el estado $q_4$, el cual no es un estado de aceptación. Por lo tanto, la palabra es rechazada.
- **Rechazo por Símbolo Inválido ("Cirthas"):** El autómata lee "Cirth" y llega a $q_F$. Sin embargo, la cadena aún tiene los caracteres `a` y `s`. Como en $q_F$ no existen transiciones de salida definidas, el autómata cae en un estado de error implícito y es rechazada.

## Implementación
La base formal de este proyecto es la traducción directa del DFA a código lógico en el archivo `automata.pl`.

La lógica en Prolog evalúa la cadena consumiendo el primer carácter, buscando la transición correspondiente y llamándose recursivamente hasta que la palabra termina y se verifica si alcanzó el estado `acepta`.

Como herramienta comparativa, se implementó la solución utilizando la expresión regular en Python en el archivo regex.py. El script evalúa la cadena completa y retorna `yes` si la palabra pertenece al lenguaje definido, o `no` si es rechazada.

### Ejemplos de entradas y salidas esperadas:

`Certhas` -> yes

`Cirth` -> yes

`Coirë` -> yes

`Coranar` -> yes

`Cormallen` -> yes

`Certh` -> no (Rechazo por prefijo incompleto)

`Cirthas` -> no (Rechazo por sufijo inválido)

`coirë` -> no (Rechazo por case-sensitivity, no inicia con mayúscula)

`Cor` -> no (Rechazo por estado de no aceptación)

`Elrond` -> no (Rechazo por símbolo no perteneciente al alfabeto de inicio)

## Pruebas
El proyecto incluye scripts de pruebas unitarias tanto para Prolog como para Python (`tests.py`). Se automatizó la validación contra una lista exhaustiva de casos positivos (todas las combinaciones válidas) y casos negativos (errores tipográficos, prefijos sueltos y cadenas vacías).

```
--- PRUEBAS DE CASOS POSITIVOS ---
Certhas -> yes
Cirth -> yes
Coirë -> yes
Coranar -> yes
Cormallen -> yes

--- PRUEBAS DE CASOS NEGATIVOS ---
Certh -> no
Cirthas -> no
coirë -> no
Cor -> no
Elrond -> no
CormallenX -> no
 -> no
true.
```

Interpretación del Reporte: Como se muestra arriba (que es una copia exacta del resultado lanzado por prolog), la implementación pasa correctamente el 100% de los casos de prueba generados. Las pruebas demuestran que el modelo se detiene exactamente donde la regla falla, validando que la estructura de árbol Trie protege al sistema de falsos positivos al no permitir la combinación cruzada de sufijos (e.g., rechaza tajantemente combinaciones como "Cirthas").

## Análisis de Complejidad y Comparativa
La complejidad temporal asintótica de mi solución es `O(n)`, donde `n` es la longitud de la cadena de texto a procesar.

### Complejidad del Modelo Base (Prolog)
- **Complejidad Temporal:** $O(n)$, donde $n$ es la longitud de la cadena procesada. Al ser un DFA puramente determinista, el algoritmo consume exactamente un carácter por iteración recursiva. No existe backtracking sintáctico.
- **Complejidad Espacial:** $O(n)$. Debido al diseño declarativo y a la evaluación recursiva de la lista de caracteres, la pila de llamadas (Call Stack) de Prolog crece de manera proporcional a la longitud de la palabra.

5.2. Comparativa: DFA en Prolog vs. Regex en PythonRendimiento Temporal:
- **Rendimiento Temporal:** Ambas soluciones son igual de rápidas y operan en un tiempo óptimo de $O(n)$. Prolog logra esto porque, al ser determinista, avanza estrictamente un carácter a la vez sin dudar.

- **Rendimiento Espacial:** En este aspecto, Python tiene la ventaja ($O(1)$ frente al $O(n)$ de Prolog). Prolog utiliza recursividad, lo que significa que el programa guarda en la memoria cada paso que da hasta terminar de leer la palabra. Python, internamente, procesa la cadena usando un ciclo simple, por lo que consume una cantidad de memoria mínima y constante sin importar qué tan larga sea la palabra ingresada.

- **Mantenibilidad y Propósito:** Prolog nos permite ver el "esqueleto" del autómata funcionando paso a paso con total transparencia, lo que lo hace perfecto para demostrar lógicamente que nuestro diseño no tiene errores. Sin embargo, si en un escenario real necesitáramos agregar cientos de palabras al diccionario, escribir cada estado a mano dejaría de ser práctico. Ahí es donde la Expresión Regular en Python demuestra su valor: condensa todo ese comportamiento lógico exacto en una sola línea de código, siendo la evolución natural para llevar el modelo teórico a un entorno de producción.

### Referencias
Aho, A. V., Lam, M. S., Sethi, R., & Ullman, J. D. (2006). Compilers: Principles, Techniques, and Tools (2nd ed.). Pearson Education.

Sipser, M. (2012). Introduction to the Theory of Computation (3rd ed.). Cengage Learning.

re — Regular expression operations. (n.d.). Python Documentation. https://docs.python.org/es/3.13/library/re.html
