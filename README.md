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
