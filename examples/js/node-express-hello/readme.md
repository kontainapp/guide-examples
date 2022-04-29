# reference
from: https://www.tutorialspoint.com/nodejs/nodejs_express_framework.htm

# docker build
```bash
docker build -t kg/jsexpress:latest .
```

# docker run
```bash
docker run --runtime=krun -p 8080:8080  kg/jsexpress:latest
```

# test
```bash
curl  http://localhost:8080/
Hello from Kontain!
```