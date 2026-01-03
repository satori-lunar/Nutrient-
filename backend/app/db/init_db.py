from sqlalchemy.orm import Session

from app.core.config import settings
from app.db.session import SessionLocal
from app.db.base import Base  # noqa: F401

# Import all models here to ensure they are registered with SQLAlchemy
from app.models.user import User, FamilyAccount, FamilyMember, UserProfile  # noqa: F401
from app.models.pantry import PantryItem, PantryRecipeMatch, Recipe, RecipeIngredient, ExpirationAlert  # noqa: F401
from app.models.meal_planning import MealPlan, MealPlanRecipe, SharedMealPlan, ShoppingList, ShoppingListItem, NutritionLog  # noqa: F401


def init_db(db: Session) -> None:
    # Create all tables
    Base.metadata.create_all(bind=db.get_bind())
