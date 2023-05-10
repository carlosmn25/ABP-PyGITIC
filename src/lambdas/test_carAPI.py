import requests
import json

API_URL = "https://uegpkrf5k4o2rfwz7y2lmw2bku0nvxqd.lambda-url.us-east-1.on.aws/" # !!! Cambiar cuando se despliegue la infraestructura !!!
TEST_CASE = 2 # 0: ID_PuntoCarga, 1: Área de búsqueda, 2: Error

if (TEST_CASE == 0):
    item = {
        "ID_PuntoCarga": 1
    }
elif (TEST_CASE == 1):
    item = {
        "lat1": 1,
        "lat2": 5,
        "lon1": 1,
        "lon2": 5
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
        print("Punto de carga con ID: " + str(json.loads(res.text)['ID_Estado']) + "; Estado: " + str(json.loads(res.text)['Estado']))
    elif(TEST_CASE == 1):
        print("Electrolineras en el área: ")
        print(json.dumps(json.loads(res.text), indent=4, sort_keys=True))