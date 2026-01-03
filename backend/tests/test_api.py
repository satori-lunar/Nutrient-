from fastapi.testclient import TestClient

from app.main import app

client = TestClient(app)


def test_read_main():
    response = client.get("/")
    assert response.status_code == 404  # No root endpoint defined


def test_read_users():
    response = client.get("/api/v1/users/")
    assert response.status_code == 200
    # Should return empty list initially


def test_create_user():
    data = {"email": "test@example.com", "password": "password123", "full_name": "Test User"}
    response = client.post("/api/v1/users/", json=data)
    assert response.status_code == 200
    content = response.json()
    assert content["email"] == data["email"]
    assert "id" in content


def test_create_user_duplicate_email():
    data = {"email": "test@example.com", "password": "password123", "full_name": "Test User"}
    response = client.post("/api/v1/users/", json=data)
    assert response.status_code == 400
