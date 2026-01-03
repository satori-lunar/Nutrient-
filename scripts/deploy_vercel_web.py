#!/usr/bin/env python3
"""
Script to deploy the Nutrient web app to Vercel.
This creates a web version of the iOS app for demonstration.
"""

import os
import subprocess
import sys
from pathlib import Path

def run_command(command, cwd=None, check=True):
    """Run a shell command."""
    try:
        result = subprocess.run(command, shell=True, cwd=cwd, capture_output=True, text=True)
        if check and result.returncode != 0:
            print(f"❌ Command failed: {command}")
            print(f"STDOUT: {result.stdout}")
            print(f"STDERR: {result.stderr}")
            return False
        return True
    except Exception as e:
        print(f"❌ Error running command: {e}")
        return False

def deploy_web_to_vercel():
    """Deploy the web app to Vercel."""
    web_dir = Path(__file__).parent.parent / "web"

    print("🚀 Deploying Nutrient Web App to Vercel...")
    print("This creates a web version of your iOS app for demonstration.\n")

    # Check if we're in the web directory
    if not (web_dir / "package.json").exists():
        print("❌ Web directory not found")
        return False

    # Check if Vercel CLI is installed
    if not run_command("vercel --version", check=False):
        print("📦 Installing Vercel CLI...")
        if not run_command("npm install -g vercel"):
            print("❌ Failed to install Vercel CLI")
            return False

    # Install dependencies
    print("📦 Installing dependencies...")
    if not run_command("npm install", cwd=web_dir):
        return False

    # Build the app
    print("🔨 Building the app...")
    if not run_command("npm run build", cwd=web_dir):
        return False

    # Deploy to Vercel
    print("🌐 Deploying to Vercel...")
    print("Note: You'll be prompted to login to Vercel if you haven't already.\n")

    if not run_command("vercel --prod", cwd=web_dir):
        print("❌ Deployment failed")
        return False

    print("\n✅ Web app deployed successfully!")
    print("Your Nutrient app is now live on Vercel!")
    print("\nNext steps:")
    print("1. Visit the Vercel URL to see your app")
    print("2. Test the different tabs and features")
    print("3. Share the URL with others to show the design")

    return True

def main():
    print("🌐 Nutrient Web App - Vercel Deployment")
    print("=" * 50)

    # Check Node.js
    if not run_command("node --version", check=False):
        print("❌ Node.js not found. Please install Node.js first:")
        print("   https://nodejs.org/")
        return False

    # Check npm
    if not run_command("npm --version", check=False):
        print("❌ npm not found. Please install npm with Node.js")
        return False

    success = deploy_web_to_vercel()
    if success:
        print("\n🎉 Ready to view your app!")
        print("The web version demonstrates the core functionality of your iOS app.")
    else:
        print("\n❌ Deployment failed. Check the errors above.")
        sys.exit(1)

if __name__ == "__main__":
    main()
