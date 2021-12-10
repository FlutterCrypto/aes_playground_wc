```plaintext
AES CBC/GCM-256 PBKDF2 example

Klartext: Mein wichtiges Geheimnis
Passwort: Passwort1234
```

CBC-Data:
```plaintext
{
  "algorithm": "AES-256 CBC PBKDF2",
  "iterations": "15000",
  "salt": "DDMReRTFCryYjwgUtXQLPQWdWTkdZD+2uHrVv1n4e3Y=",
  "iv": "RthZShR8D1wIawAekH7pTw==",
  "ciphertext": "KQ3RO2VxHvgNKfuY4PF6iOH5BK5iM1m7yx0kQ7l5Dio=",
  "gcmTag": "nicht benutzt"
}
```

GCM-Data:
```plaintext
{
  "algorithm": "AES-256 GCM PBKDF2",
  "iterations": "15000",
  "salt": "6bcqCf8f3Ah+4/j5FOz2SqQWCc/cGA6PukZQrrlY0lk=",
  "iv": "ZQSqdPS2YZLxqhx5",
  "ciphertext": "bdDog+lCOvPCk8LkDlGajU0VqMwUJEdMRDBNvOi6/0FUTigK73THLA==",
  "gcmTag": "an ciphertext angehängt"
}
```
