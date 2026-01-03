from typing import Any, Dict, Optional, Union, List

from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.pantry import PantryItem, PantryRecipeMatch, Recipe, RecipeIngredient, ExpirationAlert
from app.schemas.pantry import PantryItemCreate, PantryItemUpdate


class CRUDPantryItem(CRUDBase[PantryItem, PantryItemCreate, PantryItemUpdate]):
    def get_by_user(self, db: Session, *, user_id: int, skip: int = 0, limit: int = 100) -> List[PantryItem]:
        return db.query(PantryItem).filter(PantryItem.user_id == user_id).offset(skip).limit(limit).all()

    def get_expiring_soon(self, db: Session, *, user_id: int, days: int = 7) -> List[PantryItem]:
        # This would need a date calculation - simplified for now
        return db.query(PantryItem).filter(PantryItem.user_id == user_id).all()


class CRUDRecipe(CRUDBase[Recipe, Dict[str, Any], Dict[str, Any]]):
    def search_by_ingredients(self, db: Session, *, ingredient_names: List[str]) -> List[Recipe]:
        # Simplified search - in reality would need more complex matching logic
        recipes = db.query(Recipe).all()
        return recipes

    def get_cook_now_suggestions(self, db: Session, *, user_id: int, pantry_items: List[str]) -> List[Recipe]:
        # Simplified logic - would need pantry matching algorithm
        recipes = db.query(Recipe).limit(10).all()
        return recipes


class CRUDExpirationAlert(CRUDBase[ExpirationAlert, Dict[str, Any], Dict[str, Any]]):
    def get_by_user(self, db: Session, *, user_id: int, is_read: Optional[bool] = None) -> List[ExpirationAlert]:
        query = db.query(ExpirationAlert).filter(ExpirationAlert.user_id == user_id)
        if is_read is not None:
            query = query.filter(ExpirationAlert.is_read == is_read)
        return query.all()


pantry_item = CRUDPantryItem(PantryItem)
recipe = CRUDRecipe(Recipe)
expiration_alert = CRUDExpirationAlert(ExpirationAlert)
