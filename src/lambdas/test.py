import requests
import json

API_URL = "https://sdotklear5u3ecfdtdqk4xku4a0gbfcn.lambda-url.us-east-1.on.aws/"

#res = requests.post(API_URL)

item = {
  "key1": "CARLOS CABRON",
  "key2": "value2",
  "key3": "value3"
}

"""res = requests.get(API_URL)

print("GET")
print(res.status_code)
print(res.text)"""

res = requests.post(API_URL, json=item)

print("POST")
print(res.status_code)
print(res.text)
