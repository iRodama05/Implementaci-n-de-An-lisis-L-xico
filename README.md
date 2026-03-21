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

NFA 1 -> RE 1: C(erthas|irth)

NFA 2 -> RE 2: Coirë

NFA 3 -> RE 3: Cor(anar|mallen)

DFA Final -> RE Final: C(erthas|irth|o(irë|r(anar|mallen)))


### Referencias
Aho, A. V., Lam, M. S., Sethi, R., & Ullman, J. D. (2006). Compilers: Principles, Techniques, and Tools (2nd ed.). Pearson Education.

Sipser, M. (2012). Introduction to the Theory of Computation (3rd ed.). Cengage Learning.
