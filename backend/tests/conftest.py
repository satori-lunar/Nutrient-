from typing import Generator

import pytest
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from app.core.config import settings
from app.db.base import Base
from app.db.session import SessionLocal


@pytest.fixture(scope="session")
def db() -> Generator:
    # Create test database
    engine = create_engine(settings.DATABASE_URI + "_test", pool_pre_ping=True)
    SessionLocalTest = sessionmaker(autocommit=False, autoflush=False, bind=engine)

    # Create tables
    Base.metadata.create_all(bind=engine)

    db = SessionLocalTest()
    try:
        yield db
    finally:
        db.close()
        # Drop tables
        Base.metadata.drop_all(bind=engine)
