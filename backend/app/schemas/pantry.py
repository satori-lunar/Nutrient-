from datetime import date
from typing import List, Optional

from pydantic import BaseModel


class PantryItemBase(BaseModel):
    name: str
    barcode: Optional[str] = None
    quantity: float = 1.0
    unit: str = "count"
    category: Optional[str] = None
    expiration_date: Optional[date] = None
    purchase_date: Optional[date] = None
    estimated_value: Optional[float] = None
    is_perishable: bool = True
    storage_location: Optional[str] = None
    notes: Optional[str] = None


class PantryItemCreate(PantryItemBase):
    user_id: int


class PantryItemUpdate(PantryItemBase):
    pass


class PantryItem(PantryItemBase):
    id: Optional[int] = None
    user_id: int

    class Config:
        from_attributes = True


class RecipeIngredientBase(BaseModel):
    name: str
    quantity: float
    unit: str
    is_optional: bool = False
    notes: Optional[str] = None


class RecipeIngredientCreate(RecipeIngredientBase):
    recipe_id: int


class RecipeIngredient(RecipeIngredientBase):
    id: Optional[int] = None
    recipe_id: int

    class Config:
        from_attributes = True


class RecipeBase(BaseModel):
    name: str
    description: Optional[str] = None
    instructions: Optional[str] = None
    prep_time_minutes: int = 15
    cook_time_minutes: int = 30
    servings: int = 4
    difficulty: str = "easy"
    cuisine_type: Optional[str] = None
    cultural_background: Optional[str] = None
    is_vegetarian: bool = False
    is_vegan: bool = False
    is_gluten_free: bool = False
    is_dairy_free: bool = False
    calories: Optional[int] = None
    protein_grams: Optional[float] = None
    carbs_grams: Optional[float] = None
    fat_grams: Optional[float] = None


class RecipeCreate(RecipeBase):
    ingredients: List[RecipeIngredientCreate]


class RecipeUpdate(RecipeBase):
    ingredients: Optional[List[RecipeIngredientCreate]] = None


class Recipe(RecipeBase):
    id: Optional[int] = None
    ingredients: List[RecipeIngredient] = []

    class Config:
        from_attributes = True


class ExpirationAlertBase(BaseModel):
    alert_type: str  # "expiring_soon", "expired", "waste_risk"
    days_until_expiration: int
    message: str
    is_read: bool = False


class ExpirationAlertCreate(ExpirationAlertBase):
    user_id: int
    pantry_item_id: int


class ExpirationAlert(ExpirationAlertBase):
    id: Optional[int] = None
    user_id: int
    pantry_item_id: int

    class Config:
        from_attributes = True
