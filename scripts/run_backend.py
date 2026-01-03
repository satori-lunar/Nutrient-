#!/usr/bin/env python3
"""
Script to run the Nutrient backend server.
"""

import uvicorn
from app.db.init_db import init_db
from app.db.session import engine

def create_tables():
    """Create database tables."""
    init_db(engine)
    print("Database tables created successfully!")

if __name__ == "__main__":
    # Create tables on startup
    create_tables()

    # Run the server
    uvicorn.run(
        "app.main:app",
        host="0.0.0.0",
        port=8000,
        reload=True,
        log_level="info"
    )
