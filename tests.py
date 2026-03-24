# Importamos la función que creamos en el otro archivo
from regex import validar_palabra

def ejecutar_pruebas():
    # Lista de ejemplos validos
    casos_aceptados = [
        "Certhas",
        "Cirth",
        "Coirë",
        "Coranar",
        "Cormallen"
    ]

    # Lista de ejemplos invalidos
    casos_rechazados = [
        "Certh",        # Prefijo incompleto
        "Cirthas",      # Mezcla de sufijos inválida
        "coirë",        # Error de mayúscula inicial (case-sensitive)
        "Cor",          # Palabra incompleta
        "Elrond",       # Palabra que no pertenece al lenguaje
        "",             # Cadena vacía
        "CormallenX"    # Caracteres extra al final
    ]

    print("--- INICIANDO PRUEBAS DEL ANALIZADOR LÉXICO ---\n")
    
    print("1. Probando casos válidos (Esperado: yes)")
    for palabra in casos_aceptados:
        resultado = validar_palabra(palabra)
        print(f"[{resultado}] - '{palabra}'")

    print("\n2. Probando casos inválidos (Esperado: no)")
    for palabra in casos_rechazados:
        resultado = validar_palabra(palabra)
        print(f"[{resultado}] - '{palabra}'")

if __name__ == "__main__":
    ejecutar_pruebas()