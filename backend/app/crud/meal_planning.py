from typing import Any, Dict, Optional, Union, List

from sqlalchemy.orm import Session
from sqlalchemy import and_

from app.crud.base import CRUDBase
from app.models.meal_planning import MealPlan, MealPlanRecipe, ShoppingList, ShoppingListItem, NutritionLog
from app.schemas.meal_planning import MealPlanCreate, MealPlanUpdate


class CRUDMealPlan(CRUDBase[MealPlan, MealPlanCreate, MealPlanUpdate]):
    def get_by_user(self, db: Session, *, user_id: int, skip: int = 0, limit: int = 100) -> List[MealPlan]:
        return db.query(MealPlan).filter(MealPlan.user_id == user_id).offset(skip).limit(limit).all()

    def generate_meal_plan(self, db: Session, *, request: Dict[str, Any]) -> MealPlan:
        """
        Generate a meal plan based on user preferences and constraints.
        This is a simplified implementation - in a real app, this would be much more sophisticated.
        """
        from datetime import datetime, timedelta

        user_id = request["user_id"]
        start_date = request["start_date"]
        end_date = request["end_date"]

        # Create a basic meal plan
        meal_plan = MealPlan(
            user_id=user_id,
            name=f"Meal Plan {start_date.strftime('%B %d')}",
            start_date=start_date,
            end_date=end_date,
            budget_limit=100.0,  # Default budget
            total_estimated_cost=0.0
        )

        db.add(meal_plan)
        db.flush()  # Get the ID

        # Generate some basic recipes for the plan
        # This is very simplified - real implementation would use complex algorithms
        current_date = start_date
        meal_types = ["breakfast", "lunch", "dinner"]

        while current_date <= end_date:
            for meal_type in meal_types:
                # Create a simple recipe entry
                recipe = MealPlanRecipe(
                    meal_plan_id=meal_plan.id,
                    recipe_id=1,  # Placeholder recipe ID
                    scheduled_date=current_date,
                    meal_type=meal_type,
                    servings=4,
                    is_alternative=False,
                    notes=None
                )
                db.add(recipe)

            current_date += timedelta(days=1)

        db.commit()
        db.refresh(meal_plan)
        return meal_plan


class CRUDMealPlanRecipe(CRUDBase[MealPlanRecipe, Dict[str, Any], Dict[str, Any]]):
    def get_by_meal_plan(self, db: Session, *, meal_plan_id: int) -> List[MealPlanRecipe]:
        return db.query(MealPlanRecipe).filter(MealPlanRecipe.meal_plan_id == meal_plan_id).all()


class CRUDShoppingList(CRUDBase[ShoppingList, Dict[str, Any], Dict[str, Any]]):
    def get_by_meal_plan(self, db: Session, *, meal_plan_id: int) -> Optional[ShoppingList]:
        return db.query(ShoppingList).filter(ShoppingList.meal_plan_id == meal_plan_id).first()

    def generate_from_meal_plan(self, db: Session, *, meal_plan_id: int) -> ShoppingList:
        """
        Generate a shopping list from a meal plan.
        This is simplified - real implementation would aggregate ingredients from recipes.
        """
        shopping_list = ShoppingList(
            meal_plan_id=meal_plan_id,
            store_name="Local Grocery Store",
            store_location="123 Main St",
            total_estimated_cost=75.50,
            is_completed=False
        )

        db.add(shopping_list)
        db.flush()

        # Add some sample shopping list items
        sample_items = [
            {"name": "Chicken Breast", "quantity": 2.0, "unit": "lbs", "estimated_price": 8.99, "category": "Meat"},
            {"name": "Rice", "quantity": 5.0, "unit": "lbs", "estimated_price": 4.99, "category": "Pantry"},
            {"name": "Broccoli", "quantity": 1.0, "unit": "head", "estimated_price": 2.49, "category": "Produce"},
            {"name": "Milk", "quantity": 1.0, "unit": "gallon", "estimated_price": 3.99, "category": "Dairy"}
        ]

        for item_data in sample_items:
            item = ShoppingListItem(
                shopping_list_id=shopping_list.id,
                **item_data
            )
            db.add(item)

        db.commit()
        db.refresh(shopping_list)
        return shopping_list


class CRUDNutritionLog(CRUDBase[NutritionLog, Dict[str, Any], Dict[str, Any]]):
    def get_by_user_and_date_range(self, db: Session, *, user_id: int, start_date: Any, end_date: Any) -> List[NutritionLog]:
        return db.query(NutritionLog).filter(
            and_(
                NutritionLog.user_id == user_id,
                NutritionLog.date >= start_date,
                NutritionLog.date <= end_date
            )
        ).all()


meal_plan = CRUDMealPlan(MealPlan)
meal_plan_recipe = CRUDMealPlanRecipe(MealPlanRecipe)
shopping_list = CRUDShoppingList(ShoppingList)
nutrition_log = CRUDNutritionLog(NutritionLog)
