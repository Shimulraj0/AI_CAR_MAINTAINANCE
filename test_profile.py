import requests
import json

headers = {
    'Accept': 'application/json',
    'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzczMzEyODQyLCJpYXQiOjE3NzMyMjY0NDIsImp0aSI6ImJlY2YzMjA0NjM0NjQ2OTI4ZTQ2MGEwODhlZTU5YWZmIiwidXNlcl9pZCI6IjY1YzA4OTYyLTUwOWYtNDU1ZC1hZmI5LTIyYmYxYmZkZTMyNSJ9.9u16hWa_RSiiHGH6xp40f9Rb_Di6pmkeY3sqzSiQCU0'
}

response = requests.get('http://10.10.7.120:8000/api/user/me/', headers=headers)
print("Status Code:", response.status_code)
try:
    print(json.dumps(response.json(), indent=2))
except:
    print(response.text)
