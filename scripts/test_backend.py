#!/usr/bin/env python3
"""
Script to run backend tests.
"""

import subprocess
import sys

def run_tests():
    """Run the backend tests."""
    try:
        result = subprocess.run([
            sys.executable, "-m", "pytest",
            "backend/tests/",
            "-v",
            "--tb=short"
        ], capture_output=True, text=True)

        print("STDOUT:")
        print(result.stdout)

        if result.stderr:
            print("STDERR:")
            print(result.stderr)

        return result.returncode == 0

    except Exception as e:
        print(f"Error running tests: {e}")
        return False

if __name__ == "__main__":
    print("Running backend tests...")
    success = run_tests()

    if success:
        print("✅ All tests passed!")
        sys.exit(0)
    else:
        print("❌ Tests failed!")
        sys.exit(1)
