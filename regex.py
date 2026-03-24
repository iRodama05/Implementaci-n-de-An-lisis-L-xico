import re

def validar_palabra(cadena):
    # El símbolo '^' indica el inicio de la cadena y '$' indica el final.
    # Esto asegura que evalúe la palabra completa y exacta, no solo una parte.
    patron = r"^C(erthas|irth|o(irë|r(anar|mallen)))$"
    
    # re.match busca si la cadena cumple con el patrón establecido
    if re.match(patron, cadena):
        return "yes"
    else:
        return "no"

# Esto permite probar el código manualmente si se ejecuta este archivo :D
if __name__ == "__main__":
    print("Analizador Léxico Élfico")
    print("Escribe 'salir' para terminar.")
    
    while True: # Te pide ingresar tu ejemplo manualmente. Inutil si se usa el otro script
        entrada = input("Ingresa una palabra para analizar: ")
        if entrada.lower() == 'salir':
            break
            
        resultado = validar_palabra(entrada)
        print(f"{entrada} -> {resultado}\n")