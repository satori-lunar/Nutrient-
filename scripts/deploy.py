#!/usr/bin/env python3
"""
Main deployment script for the Nutrient application.
"""

import argparse
import sys
from pathlib import Path

def deploy_backend():
    """Deploy the backend."""
    print("🔧 Deploying backend...")
    deploy_script = Path(__file__).parent / "deploy_backend.py"
    if not deploy_script.exists():
        print("❌ Backend deployment script not found")
        return False

    # Import and run the backend deployment
    try:
        import subprocess
        result = subprocess.run([sys.executable, str(deploy_script)], capture_output=True, text=True)
        if result.returncode != 0:
            print("Backend deployment failed:")
            print(result.stderr)
            return False
        print(result.stdout)
        return True
    except Exception as e:
        print(f"Error deploying backend: {e}")
        return False

def deploy_ios():
    """Deploy the iOS app."""
    print("📱 Deploying iOS app...")
    deploy_script = Path(__file__).parent / "deploy_ios.py"
    if not deploy_script.exists():
        print("❌ iOS deployment script not found")
        return False

    # Import and run the iOS deployment
    try:
        import subprocess
        result = subprocess.run([sys.executable, str(deploy_script)], capture_output=True, text=True)
        if result.returncode != 0:
            print("iOS deployment failed:")
            print(result.stderr)
            return False
        print(result.stdout)
        return True
    except Exception as e:
        print(f"Error deploying iOS: {e}")
        return False

def main():
    parser = argparse.ArgumentParser(description="Deploy the Nutrient application")
    parser.add_argument("--backend", action="store_true", help="Deploy only the backend")
    parser.add_argument("--ios", action="store_true", help="Deploy only the iOS app")
    parser.add_argument("--all", action="store_true", help="Deploy both backend and iOS (default)")

    args = parser.parse_args()

    # Default to deploying all if no specific target
    if not (args.backend or args.ios):
        args.all = True

    success = True

    if args.backend or args.all:
        if not deploy_backend():
            success = False

    if args.ios or args.all:
        if not deploy_ios():
            success = False

    if success:
        print("\n🎉 Deployment completed successfully!")
        print("\nNext steps:")
        print("- Test the application thoroughly")
        print("- Monitor for any issues")
        print("- Gather user feedback")
        print("- Plan for future updates")
    else:
        print("\n❌ Deployment failed!")
        sys.exit(1)

if __name__ == "__main__":
    main()
