from flask import Flask
app = Flask(__name__)

@app.route("/")
def hello():
    return '{"message":"Hello from Kontain!"}'

if __name__ == "__main__":
    app.run(host='0.0.0.0')
