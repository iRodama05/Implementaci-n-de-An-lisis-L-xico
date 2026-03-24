# Implementación de Análisis Léxico
## Descripción
### Lenguaje Seleccionado:
El lenguaje elegido consiste en un conjunto finito de palabras específicas pertenecientes a las lenguas élficas: Certhas, Cirth, Coirë, Coranar y Cormallen.
Aunque se trata de un conjunto de palabras de un idioma de ficción, este problema nos ayuda a adentrarnos en los fundamentos de las ciencias de la computación. Las reglas que sigue este modelo son las mismas que se utilizan para construir analizadores léxicos (la primera fase de un compilador). En palabras simples, es el mismo proceso que usa una computadora cuando lee el código fuente de un programa y logra identificar cuáles son las "palabras reservadas" (como if, while o for) dentro de todo el texto.

### Técnicas de Modelado y Justificación:
Para modelar la solución, decidí utilizar en conjunto Expresiones Regulares (RE) y un Autómata Finito Determinista (DFA).

Primero, las expresiones regulares se utilizan porque proporcionan una notación declarativa y concisa. Es decir, son una forma matemática muy resumida de escribir exactamente qué patrones de letras estamos buscando, sin tener que escribir código complejo.

Para la implementación del programa, se optó por un DFA. De acuerdo con Alfred V. Aho. (2006) en su obra Compilers: Principles, Techniques, and Tools, los autómatas finitos son los modelos estándar para construir estos analizadores por su alta eficiencia. Básicamente, permiten validar una palabra en tiempo lineal (complejidad O(n)); esto significa que la computadora solo necesita leer la palabra una vez, letra por letra, y el tiempo que tarda depende únicamente de qué tan larga sea la palabra, sin hacer cálculos extra.

Se eligió diseñar un DFA en lugar de un Autómata Finito No Determinista (NFA). Como señala Sipser (2012) en Introduction to the Theory of Computation, aunque ambos sirven para reconocer el mismo tipo de lenguajes, el DFA tiene una gran ventaja al momento de programarlo: garantiza que, por cada letra que se lee, solo existe un camino posible a seguir. Esto significa que nuestro programa no tendrá que "adivinar" opciones, evaluar múltiples caminos al mismo tiempo, ni retroceder si se equivoca (una técnica de fuerza bruta conocida como backtracking). El resultado es un código mucho más directo, rápido y fácil de construir.

## Modelado de la solución
El primer autómata (NFA 1) se utiliza para representar las palabras del lenguaje que comparten la raíz "C" seguida de las vocales "e" o "i" (Certhas y Cirth).
![94f7d7d6-442b-4e69-a1a7-722b90b8ab6a](https://github.com/user-attachments/assets/ec1d6b4c-3435-4bf4-b05a-63889a1f3516)

El segundo autómata (NFA 2) se utiliza para representar la palabra que se bifurca directamente hacia la terminación "irë" (Coirë).

El tercer autómata (NFA 3) se utiliza para representar las palabras que comparten el prefijo "Cor" (Coranar y Cormallen).

Decidí utilizar tres Autómatas Finitos No Deterministas (NFA) diferentes inicialmente porque resulta más sencillo modelar el vocabulario dividiéndolo en subgrupos lógicos. Sin embargo, al tener NFA, tuve que transformarlos y unificarlos en un solo Autómata Finito Determinista (DFA) para poder programar este último de manera eficiente y evitar la ambigüedad en las transiciones, en lugar de intentar adivinar la estructura final. Para hacer esto, seguí el algoritmo de construcción de subconjuntos (subset construction) propuesto originalmente por Rabin y Scott, tal como se detalla en Aho et al. (2006).

El autómata resultante (DFA) fue el siguiente:

Los autómatas presentados son equivalentes a las siguientes expresiones regulares (RE):

NFA 1 -> RE 1: `C(erthas|irth)`

NFA 2 -> RE 2: `Coirë`

NFA 3 -> RE 3: `Cor(anar|mallen)`

DFA Final -> RE Final: `C(erthas|irth|o(irë|r(anar|mallen)))`

## Implementación
Para la implementación de este análisis léxico, decidí utilizar la expresión regular optimizada (factorizada por la izquierda) derivada de mis modelos, la cual se encuentra en el archivo `regex.py`.

Para utilizar el programa, el usuario debe ingresar una cadena de texto (por ejemplo, "Certhas"). El script evalúa la cadena completa y retorna `yes` si la palabra pertenece al lenguaje élfico definido, o `no` si es rechazada.

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
El archivo `tests.py` contiene el script de pruebas unitarias (Unit Tests). En este script se automatiza la validación de la expresión regular contra una lista exhaustiva de casos de prueba positivos (todas las combinaciones válidas) y casos de prueba negativos (errores tipográficos, prefijos sueltos y cadenas vacías) para asegurar que el reconocedor no genere falsos positivos.

## Análisis
La complejidad temporal asintótica de mi solución es `O(n)`, donde `n` es la longitud de la cadena de texto a procesar.

### Demostración de complejidad:
El comportamiento de un Autómata Finito Determinista (DFA), en el cual se basa nuestra expresión regular estricta, evalúa un solo carácter a la vez sin necesidad de retroceder. En un análisis a mano, el seudocódigo de la transición de estados es:
```
estado_actual = q0
para cada caracter 'c' en la cadena de longitud n:
    estado_actual = matriz_transicion[estado_actual][c]
    si estado_actual es ERROR:
        romper ciclo y rechazar
si estado_actual es de ACEPTACION:
    aceptar
```
Como la búsqueda en la matriz de transición para cada carácter toma un tiempo constante `O(1)`, y el ciclo se repite `n` veces, el tiempo total en el peor de los casos está acotado por `O(n)`.

Para la implementación en Python, utilicé la librería re. Aunque la literatura advierte que las expresiones regulares pueden volverse muy lentas (llegando a una complejidad de `O(2^n))` si el programa tiene que retroceder constantemente para adivinar caminos (backtracking), este caso es diferente. Al haber factorizado la expresión como `^C(erthas|irth|o(irë|r(anar|mallen)))$` y usar los anclajes de inicio (^) y fin ($), eliminamos cualquier ambigüedad. Esto significa que Python lee la palabra de forma directa sin tener que retroceder nunca, manteniendo un tiempo de ejecución eficiente y lineal de `O(n)`.

### Comparación con soluciones alternativas:
La alternativa directa habría sido programar el autómata (DFA) manualmente, utilizando múltiples condicionales (`if-else` o `switch-case`) para representar cada uno de los 26 estados. Aunque esa programación manual también es válida y garantiza un tiempo de ejecución de `O(n)`, el enfoque con Expresiones Regulares es superior porque es mucho más fácil de leer y mantener. Al usar una RE concisa, se logra resolver el problema en una sola línea de código, delegando la construcción interna del autómata al motor de Python y manteniendo el mismo rendimiento óptimo de `O(n)`.

### Referencias
Aho, A. V., Lam, M. S., Sethi, R., & Ullman, J. D. (2006). Compilers: Principles, Techniques, and Tools (2nd ed.). Pearson Education.

Sipser, M. (2012). Introduction to the Theory of Computation (3rd ed.). Cengage Learning.
