import requests
import json

API_URL = "https://3idnb5jxiibwwmrargbz2fjw7i0xxwco.lambda-url.us-east-1.on.aws/" # !!! Cambiar cuando se despliegue la infraestructura !!!
TEST_CASE = 0 # 0: ID_PuntoCarga, 1: Área de búsqueda, 2: Error

estados = {
    '0' : "Libre",
    '1' : "Ocupado",
    '2' : "Fuera de servicio"
}

if (TEST_CASE == 0):
    item = {
        "ID_PuntoCarga": 3
    }
elif (TEST_CASE == 1):
    item = {
        "lat1": 100,
        "lat2": -100,
        "lon1": 100,
        "lon2": -100
    }
elif (TEST_CASE == 2):
    item = {
        "asdf": 1,
    }

res = requests.post(API_URL, json=item)

if (res.status_code != 200):
    print("Error: " + str(res.status_code))
    print(res.text)
    exit()
else:
    print("Petición realizada con éxito")
    if (TEST_CASE == 0):
        #print("Punto de carga con ID: " + str(json.loads(res.text)[0]['ID_PuntoCarga']) + "; Estado: " + estados[str(json.loads(res.text)[0]['estado'])] )
        print(res.text)
    elif(TEST_CASE == 1):
        print("Electrolineras en el área: ")
        print(json.dumps(json.loads(res.text), indent=4, sort_keys=True))