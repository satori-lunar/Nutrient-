from sqlalchemy.orm import Session

from app import crud
from app.schemas.user import UserCreate


def create_random_user(db: Session) -> crud.User:
    email = f"user{random.randint(0, 1000)}@example.com"
    password = "password123"
    user_in = UserCreate(email=email, password=password, full_name="Random User")
    return crud.user.create(db, obj_in=user_in)
