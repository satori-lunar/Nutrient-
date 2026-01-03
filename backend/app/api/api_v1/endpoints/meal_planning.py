from typing import Any, List

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app import crud, models, schemas
from app.api import deps

router = APIRouter()


@router.get("/", response_model=List[schemas.MealPlan])
def read_meal_plans(
    db: Session = Depends(deps.get_db),
    skip: int = 0,
    limit: int = 100,
    user_id: int = None,
) -> Any:
    """
    Retrieve meal plans for a user.
    """
    if user_id is None:
        raise HTTPException(status_code=400, detail="user_id parameter is required")
    meal_plans = crud.meal_plan.get_by_user(db, user_id=user_id, skip=skip, limit=limit)
    return meal_plans


@router.post("/", response_model=schemas.MealPlan)
def create_meal_plan(
    *,
    db: Session = Depends(deps.get_db),
    meal_plan_in: schemas.MealPlanCreate,
) -> Any:
    """
    Create new meal plan.
    """
    meal_plan = crud.meal_plan.create(db, obj_in=meal_plan_in)
    return meal_plan


@router.post("/generate", response_model=schemas.MealPlan)
def generate_meal_plan(
    *,
    db: Session = Depends(deps.get_db),
    request: schemas.MealPlanGenerationRequest,
) -> Any:
    """
    Generate a meal plan based on user preferences and constraints.
    """
    meal_plan = crud.meal_plan.generate_meal_plan(db, request=request.dict())
    return meal_plan


@router.get("/{meal_plan_id}", response_model=schemas.MealPlan)
def read_meal_plan(
    *,
    db: Session = Depends(deps.get_db),
    meal_plan_id: int,
) -> Any:
    """
    Get meal plan by ID.
    """
    meal_plan = crud.meal_plan.get(db, id=meal_plan_id)
    if not meal_plan:
        raise HTTPException(status_code=404, detail="Meal plan not found")
    return meal_plan


@router.put("/{meal_plan_id}", response_model=schemas.MealPlan)
def update_meal_plan(
    *,
    db: Session = Depends(deps.get_db),
    meal_plan_id: int,
    meal_plan_in: schemas.MealPlanUpdate,
) -> Any:
    """
    Update meal plan.
    """
    meal_plan = crud.meal_plan.get(db, id=meal_plan_id)
    if not meal_plan:
        raise HTTPException(status_code=404, detail="Meal plan not found")
    meal_plan = crud.meal_plan.update(db, db_obj=meal_plan, obj_in=meal_plan_in)
    return meal_plan


@router.delete("/{meal_plan_id}")
def delete_meal_plan(
    *,
    db: Session = Depends(deps.get_db),
    meal_plan_id: int,
) -> Any:
    """
    Delete meal plan.
    """
    meal_plan = crud.meal_plan.get(db, id=meal_plan_id)
    if not meal_plan:
        raise HTTPException(status_code=404, detail="Meal plan not found")
    crud.meal_plan.remove(db, id=meal_plan_id)
    return {"message": "Meal plan deleted successfully"}


@router.post("/{meal_plan_id}/shopping-list", response_model=schemas.ShoppingList)
def generate_shopping_list(
    *,
    db: Session = Depends(deps.get_db),
    meal_plan_id: int,
) -> Any:
    """
    Generate a shopping list for a meal plan.
    """
    # Check if meal plan exists
    meal_plan = crud.meal_plan.get(db, id=meal_plan_id)
    if not meal_plan:
        raise HTTPException(status_code=404, detail="Meal plan not found")

    # Check if shopping list already exists
    existing_list = crud.shopping_list.get_by_meal_plan(db, meal_plan_id=meal_plan_id)
    if existing_list:
        raise HTTPException(status_code=400, detail="Shopping list already exists for this meal plan")

    shopping_list = crud.shopping_list.generate_from_meal_plan(db, meal_plan_id=meal_plan_id)
    return shopping_list


@router.get("/{meal_plan_id}/shopping-list", response_model=schemas.ShoppingList)
def read_shopping_list(
    *,
    db: Session = Depends(deps.get_db),
    meal_plan_id: int,
) -> Any:
    """
    Get shopping list for a meal plan.
    """
    shopping_list = crud.shopping_list.get_by_meal_plan(db, meal_plan_id=meal_plan_id)
    if not shopping_list:
        raise HTTPException(status_code=404, detail="Shopping list not found")
    return shopping_list


@router.post("/nutrition-logs", response_model=schemas.NutritionLog)
def create_nutrition_log(
    *,
    db: Session = Depends(deps.get_db),
    nutrition_log_in: schemas.NutritionLogCreate,
) -> Any:
    """
    Create new nutrition log entry.
    """
    nutrition_log = crud.nutrition_log.create(db, obj_in=nutrition_log_in)
    return nutrition_log


@router.get("/nutrition-logs", response_model=List[schemas.NutritionLog])
def read_nutrition_logs(
    db: Session = Depends(deps.get_db),
    user_id: int = None,
    start_date: str = None,
    end_date: str = None,
) -> Any:
    """
    Get nutrition logs for a user within a date range.
    """
    if user_id is None:
        raise HTTPException(status_code=400, detail="user_id parameter is required")

    if start_date and end_date:
        from datetime import datetime
        start = datetime.fromisoformat(start_date)
        end = datetime.fromisoformat(end_date)
        logs = crud.nutrition_log.get_by_user_and_date_range(db, user_id=user_id, start_date=start, end_date=end)
    else:
        # Get recent logs - simplified
        logs = crud.nutrition_log.get_multi(db, limit=50)

    return logs
