#!/usr/bin/env python3
"""
Script to prepare the Nutrient backend for Vercel deployment.
Note: This requires significant refactoring for serverless functions.
"""

import os
import json
from pathlib import Path

def create_vercel_config():
    """Create Vercel configuration files."""
    # Vercel config for API routes
    vercel_config = {
        "version": 2,
        "builds": [
            {
                "src": "api/**/*.py",
                "use": "@vercel/python"
            }
        ],
        "routes": [
            {
                "src": "/api/(.*)",
                "dest": "/api/$1"
            }
        ],
        "env": {
            "DATABASE_URL": "@database_url"
        }
    }

    # Write vercel.json
    with open("backend/vercel.json", "w") as f:
        json.dump(vercel_config, f, indent=2)

    # Create api directory structure for serverless functions
    api_dir = Path("backend/api")
    api_dir.mkdir(exist_ok=True)

    # Create a sample serverless function
    sample_function = '''from http.server import BaseHTTPRequestHandler
import json

class handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.end_headers()
        self.wfile.write(json.dumps({"message": "Nutrient API on Vercel"}).encode())
    '''

    with open("backend/api/index.py", "w") as f:
        f.write(sample_function)

    print("Vercel configuration created. Note: Full conversion to serverless requires significant refactoring.")

if __name__ == "__main__":
    create_vercel_config()
    print("⚠️  WARNING: Vercel deployment requires major backend refactoring for serverless functions")
    print("   Consider using Railway or Render for the current FastAPI architecture instead.")
