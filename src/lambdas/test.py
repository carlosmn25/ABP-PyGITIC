import requests
import time

API_URL = "https://5yljen5gogx5kw4exyohbemnje0wkxws.lambda-url.us-east-1.on.aws/"

item = {
    "ID_Estado": 20,
    "estado": 1,
    "matricula": "AB9116U",
    "tiempo": int(time.time())
}

res = requests.post(API_URL, json=item)

print(res.status_code)
