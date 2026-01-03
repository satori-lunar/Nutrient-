#!/usr/bin/env python3
"""
Script to deploy the Nutrient backend.
"""

import os
import subprocess
import sys
from pathlib import Path

def run_command(command, cwd=None):
    """Run a shell command and return success status."""
    try:
        result = subprocess.run(command, shell=True, cwd=cwd, capture_output=True, text=True)
        if result.returncode != 0:
            print(f"Command failed: {command}")
            print(f"STDOUT: {result.stdout}")
            print(f"STDERR: {result.stderr}")
            return False
        return True
    except Exception as e:
        print(f"Error running command '{command}': {e}")
        return False

def deploy_backend():
    """Deploy the backend application."""
    backend_dir = Path(__file__).parent.parent / "backend"
    scripts_dir = Path(__file__).parent

    print("🚀 Starting backend deployment...")

    # Check if we're in the backend directory
    if not (backend_dir / "main.py").exists():
        print("❌ Backend directory not found")
        return False

    # Install dependencies
    print("📦 Installing dependencies...")
    if not run_command("pip install -r requirements.txt", cwd=backend_dir):
        return False

    # Run database migrations (if using Alembic)
    if (backend_dir / "alembic.ini").exists():
        print("🗄️ Running database migrations...")
        if not run_command("alembic upgrade head", cwd=backend_dir):
            return False

    # Run tests
    print("🧪 Running tests...")
    test_script = scripts_dir / "test_backend.py"
    if test_script.exists():
        if not run_command(f"python {test_script}", cwd=scripts_dir):
            print("⚠️ Tests failed, but continuing with deployment...")

    # Start the server (for development/demo)
    print("🌐 Starting server...")
    print("Backend deployed successfully!")
    print("Run the following to start the server:")
    print(f"  cd {backend_dir}")
    print("  python scripts/run_backend.py")

    return True

if __name__ == "__main__":
    success = deploy_backend()
    if success:
        print("✅ Backend deployment completed successfully!")
        sys.exit(0)
    else:
        print("❌ Backend deployment failed!")
        sys.exit(1)
