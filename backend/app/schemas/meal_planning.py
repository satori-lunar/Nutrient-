from datetime import date
from typing import List, Optional

from pydantic import BaseModel


class MealPlanRecipeBase(BaseModel):
    recipe_id: int
    scheduled_date: date
    meal_type: str  # "breakfast", "lunch", "dinner", "snack"
    servings: int = 4
    is_alternative: bool = False
    notes: Optional[str] = None


class MealPlanRecipeCreate(MealPlanRecipeBase):
    meal_plan_id: int


class MealPlanRecipe(MealPlanRecipeBase):
    id: Optional[int] = None
    meal_plan_id: int

    class Config:
        from_attributes = True


class MealPlanBase(BaseModel):
    name: str
    start_date: date
    end_date: date
    budget_limit: Optional[float] = None
    total_estimated_cost: Optional[float] = None


class MealPlanCreate(MealPlanBase):
    user_id: int


class MealPlanUpdate(MealPlanBase):
    pass


class MealPlan(MealPlanBase):
    id: Optional[int] = None
    user_id: int
    recipes: List[MealPlanRecipe] = []

    class Config:
        from_attributes = True


class MealPlanGenerationRequest(BaseModel):
    user_id: int
    start_date: date
    end_date: date
    preferences: Optional[dict] = None


class ShoppingListItemBase(BaseModel):
    name: str
    quantity: float
    unit: str
    estimated_price: Optional[float] = None
    category: Optional[str] = None
    is_purchased: bool = False
    alternative_suggestions: Optional[List[dict]] = None


class ShoppingListItemCreate(ShoppingListItemBase):
    shopping_list_id: int


class ShoppingListItem(ShoppingListItemBase):
    id: Optional[int] = None
    shopping_list_id: int

    class Config:
        from_attributes = True


class ShoppingListBase(BaseModel):
    store_name: Optional[str] = None
    store_location: Optional[str] = None
    total_estimated_cost: Optional[float] = None
    is_completed: bool = False


class ShoppingListCreate(ShoppingListBase):
    meal_plan_id: int


class ShoppingList(ShoppingListBase):
    id: Optional[int] = None
    meal_plan_id: int
    items: List[ShoppingListItem] = []

    class Config:
        from_attributes = True


class NutritionLogBase(BaseModel):
    date: date
    meal_type: str
    custom_meal_name: Optional[str] = None
    calories: Optional[int] = None
    protein_grams: Optional[float] = None
    carbs_grams: Optional[float] = None
    fat_grams: Optional[float] = None
    family_member_name: Optional[str] = None
    notes: Optional[str] = None


class NutritionLogCreate(NutritionLogBase):
    user_id: int
    recipe_id: Optional[int] = None


class NutritionLog(NutritionLogBase):
    id: Optional[int] = None
    user_id: int
    recipe_id: Optional[int] = None

    class Config:
        from_attributes = True
