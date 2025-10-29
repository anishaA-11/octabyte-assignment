from flask import Flask, jsonify
from prometheus_flask_exporter import PrometheusMetrics  # 👈 import this

app = Flask(__name__)

# 👇 initialize Prometheus metrics
metrics = PrometheusMetrics(app)

@app.route("/")
def home():
    return jsonify({"message": "Hello from Octa Byte AI Assignment!"})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
