# Build and Test Scripts

## Backend Testing

Run the backend tests:

```bash
python scripts/test_backend.py
```

This will run all pytest tests in the `backend/tests/` directory.

## Running Tests Manually

### Backend Tests

1. Install test dependencies:
```bash
cd backend
pip install -r requirements.txt
```

2. Run tests:
```bash
pytest tests/ -v
```

### iOS Tests

1. Open `ios/Nutrient.xcodeproj` in Xcode
2. Select the test target
3. Run tests (⌘+U)

## Continuous Integration

These scripts are designed to be used in CI/CD pipelines for automated testing.

## Test Coverage

To run tests with coverage:

```bash
pytest --cov=app --cov-report=html
```
