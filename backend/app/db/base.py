# Import all the models, so that Base has them before being
# imported by Alembic
from app.db.base_class import Base  # noqa: F401
from app.models.user import User, FamilyAccount, FamilyMember, UserProfile  # noqa: F401
from app.models.pantry import PantryItem, PantryRecipeMatch, Recipe, RecipeIngredient, ExpirationAlert  # noqa: F401
from app.models.meal_planning import MealPlan, MealPlanRecipe, SharedMealPlan, ShoppingList, ShoppingListItem, NutritionLog  # noqa: F401
