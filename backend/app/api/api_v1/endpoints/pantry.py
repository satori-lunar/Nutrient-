from typing import Any, List

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app import crud, models, schemas
from app.api import deps

router = APIRouter()


@router.get("/items", response_model=List[schemas.PantryItem])
def read_pantry_items(
    db: Session = Depends(deps.get_db),
    skip: int = 0,
    limit: int = 100,
    user_id: int = None,
) -> Any:
    """
    Retrieve pantry items for a user.
    """
    if user_id is None:
        raise HTTPException(status_code=400, detail="user_id parameter is required")
    items = crud.pantry_item.get_by_user(db, user_id=user_id, skip=skip, limit=limit)
    return items


@router.post("/items", response_model=schemas.PantryItem)
def create_pantry_item(
    *,
    db: Session = Depends(deps.get_db),
    item_in: schemas.PantryItemCreate,
) -> Any:
    """
    Create new pantry item.
    """
    item = crud.pantry_item.create(db, obj_in=item_in)
    return item


@router.put("/items/{item_id}", response_model=schemas.PantryItem)
def update_pantry_item(
    *,
    db: Session = Depends(deps.get_db),
    item_id: int,
    item_in: schemas.PantryItemUpdate,
) -> Any:
    """
    Update pantry item.
    """
    item = crud.pantry_item.get(db, id=item_id)
    if not item:
        raise HTTPException(status_code=404, detail="Pantry item not found")
    item = crud.pantry_item.update(db, db_obj=item, obj_in=item_in)
    return item


@router.delete("/items/{item_id}")
def delete_pantry_item(
    *,
    db: Session = Depends(deps.get_db),
    item_id: int,
) -> Any:
    """
    Delete pantry item.
    """
    item = crud.pantry_item.get(db, id=item_id)
    if not item:
        raise HTTPException(status_code=404, detail="Pantry item not found")
    crud.pantry_item.remove(db, id=item_id)
    return {"message": "Pantry item deleted successfully"}


@router.get("/cook-now", response_model=List[schemas.Recipe])
def get_cook_now_suggestions(
    db: Session = Depends(deps.get_db),
    user_id: int = None,
) -> Any:
    """
    Get recipes that can be made with current pantry items.
    """
    if user_id is None:
        raise HTTPException(status_code=400, detail="user_id parameter is required")

    # Get user's pantry items
    pantry_items = crud.pantry_item.get_by_user(db, user_id=user_id)
    pantry_item_names = [item.name.lower() for item in pantry_items]

    # Get cook-now suggestions
    recipes = crud.recipe.get_cook_now_suggestions(db, user_id=user_id, pantry_items=pantry_item_names)
    return recipes


@router.get("/expiration-alerts", response_model=List[schemas.ExpirationAlert])
def read_expiration_alerts(
    db: Session = Depends(deps.get_db),
    user_id: int = None,
    is_read: bool = None,
) -> Any:
    """
    Get expiration alerts for a user.
    """
    if user_id is None:
        raise HTTPException(status_code=400, detail="user_id parameter is required")
    alerts = crud.expiration_alert.get_by_user(db, user_id=user_id, is_read=is_read)
    return alerts
