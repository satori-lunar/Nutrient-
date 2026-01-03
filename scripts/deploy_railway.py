#!/usr/bin/env python3
"""
Script to deploy the Nutrient backend to Railway.
"""

import os
import subprocess
import sys
from pathlib import Path

def deploy_to_railway():
    """Deploy the backend to Railway."""
    backend_dir = Path(__file__).parent.parent / "backend"

    print("🚂 Deploying to Railway...")

    # Check if Railway CLI is installed
    try:
        subprocess.run(["railway", "--version"], capture_output=True, check=True)
    except (subprocess.CalledProcessError, FileNotFoundError):
        print("❌ Railway CLI not found. Install it first:")
        print("   npm install -g @railway/cli")
        print("   railway login")
        return False

    # Check if we're in a git repository
    try:
        subprocess.run(["git", "status"], cwd=backend_dir, capture_output=True, check=True)
    except subprocess.CalledProcessError:
        print("❌ Not a git repository. Initialize git first:")
        print(f"   cd {backend_dir}")
        print("   git init")
        print("   git add .")
        print("   git commit -m 'Initial commit'")
        return False

    # Create railway.toml if it doesn't exist
    railway_config = """[build]
builder = "NIXPACKS"

[deploy]
startCommand = "python scripts/run_backend.py"
healthcheckPath = "/api/v1/docs"
restartPolicyType = "ON_FAILURE"

[build.env]
PYTHON_VERSION = "3.11"
"""

    config_path = backend_dir / "railway.toml"
    if not config_path.exists():
        with open(config_path, "w") as f:
            f.write(railway_config)
        print("✅ Created railway.toml")

    # Deploy
    print("🚀 Deploying to Railway...")
    try:
        subprocess.run(["railway", "up"], cwd=backend_dir, check=True)
        print("✅ Deployment successful!")
        print("\nNext steps:")
        print("1. Set up your PostgreSQL database: railway add postgresql")
        print("2. Configure environment variables in Railway dashboard")
        print("3. Your API will be available at the Railway-provided URL")
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ Deployment failed: {e}")
        return False

if __name__ == "__main__":
    success = deploy_to_railway()
    sys.exit(0 if success else 1)
