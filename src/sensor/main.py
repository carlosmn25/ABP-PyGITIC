# Importamos la paquteria necesaria
import RPi.GPIO as GPIO
import time
import requests
import random
import string
import json

TRIG = 23  # Variable que contiene el GPIO al cual conectamos la señal TRIG del sensor
ECHO = 24  # Variable que contiene el GPIO al cual conectamos la señal ECHO del sensor

# Establecemos el modo según el cual nos refiriremos a los GPIO de nuestra RPi
GPIO.setmode(GPIO.BCM)
GPIO.setup(TRIG, GPIO.OUT)  # Configuramos el pin TRIG como una salida
GPIO.setup(ECHO, GPIO.IN)  # Configuramos el pin ECHO como una salida


# Contenemos el código principal en un aestructura try para limpiar los GPIO al terminar o presentarse un error
try:
    ocupado = False
    matricula = ""
    contador = 0
    # Implementamos un loop infinito
    while True:

        # Ponemos en bajo el pin TRIG y después esperamos 0.5 seg para que el transductor se estabilice
        GPIO.output(TRIG, GPIO.LOW)
        time.sleep(0.5)

        # Ponemos en alto el pin TRIG esperamos 10 uS antes de ponerlo en bajo
        GPIO.output(TRIG, GPIO.HIGH)
        time.sleep(0.00001)
        GPIO.output(TRIG, GPIO.LOW)

        # En este momento el sensor envía 8 pulsos ultrasónicos de 40kHz y coloca su pin ECHO en alto
        # Debemos detectar dicho evento para iniciar la medición del tiempo

        while True:
            pulso_inicio = time.time()
            if GPIO.input(ECHO) == GPIO.HIGH:
                break

        # El pin ECHO se mantendrá en HIGH hasta recibir el eco rebotado por el obstáculo.
        # En ese momento el sensor pondrá el pin ECHO en bajo.
        # Prodedemos a detectar dicho evento para terminar la medición del tiempo

        while True:
            pulso_fin = time.time()
            if GPIO.input(ECHO) == GPIO.LOW:
                break

        # Tiempo medido en segundos
        duracion = pulso_fin - pulso_inicio

        # Obtenemos la distancia considerando que la señal recorre dos veces la distancia a medir y que la velocidad del sonido es 343m/s
        distancia = (34300 * duracion) / 2
        
        if (ocupado == True) and (distancia > 50):
            ocupado = False
            item = {
                "ID_Estado": ID_Estado,
                "estado": 0,
                "matricula": matricula,
                "tiempo": int(time.time())
            }
            
            print(json.dumps(item))

            res = requests.post(API_URL, json=item)
            
            print(res.status_code, " Enviado libre")
            
            print("\n***** ESPACIO LIBERADO *****\n")
            
        elif (distancia < 50) and (ocupado == False):
            contador += 1
            print(contador,"/20 ticks")
            if contador == 20: # Cuando el sensor está a menos de 50cm durante 10 segundos
                ocupado = True
                API_URL = "https://5yljen5gogx5kw4exyohbemnje0wkxws.lambda-url.us-east-1.on.aws/"
                
                ID_Estado = random.randint(1,20)
                for i in range(3):
                    matricula += random.choice(string.ascii_uppercase)
                numero = random.randint(1000,9999)
                matricula += str(numero)

                item = {
                    "ID_Estado": ID_Estado,
                    "estado": 1,
                    "matricula": matricula,
                    "tiempo": int(time.time())
                }
                
                print(json.dumps(item))

                res = requests.post(API_URL, json=item)

                print(res.status_code, " Enviado ocupado")
                
                print("\n***** ESPACIO OCUPADO, ESPERE A SER LIBERADO *****\n")
        else:
            contador = 0

finally:
    # Reiniciamos todos los canales de GPIO.
    GPIO.cleanup()