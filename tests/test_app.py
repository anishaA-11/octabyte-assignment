from app.app import app  # Import Flask app correctly

def test_home():
    client = app.test_client()
    response = client.get("/")
    data = response.get_json()
    assert response.status_code == 200
    assert data["message"] == "Hello from Octa Byte AI Assignment!"
