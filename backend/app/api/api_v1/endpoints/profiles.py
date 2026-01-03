from typing import Any, List

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app import crud, models, schemas
from app.api import deps

router = APIRouter()


@router.get("/{user_id}", response_model=schemas.UserProfile)
def read_user_profile(
    *,
    db: Session = Depends(deps.get_db),
    user_id: int,
) -> Any:
    """
    Get user profile by user ID.
    """
    profile = crud.user_profile.get_by_user_id(db, user_id=user_id)
    if not profile:
        raise HTTPException(status_code=404, detail="Profile not found")
    return profile


@router.post("/", response_model=schemas.UserProfile)
def create_user_profile(
    *,
    db: Session = Depends(deps.get_db),
    profile_in: schemas.UserProfileCreate,
) -> Any:
    """
    Create new user profile.
    """
    # Check if profile already exists for this user
    existing_profile = crud.user_profile.get_by_user_id(db, user_id=profile_in.user_id)
    if existing_profile:
        raise HTTPException(
            status_code=400,
            detail="Profile already exists for this user. Use PUT to update instead.",
        )

    profile = crud.user_profile.create(db, obj_in=profile_in)
    return profile


@router.put("/{profile_id}", response_model=schemas.UserProfile)
def update_user_profile(
    *,
    db: Session = Depends(deps.get_db),
    profile_id: int,
    profile_in: schemas.UserProfileUpdate,
) -> Any:
    """
    Update user profile.
    """
    profile = crud.user_profile.get(db, id=profile_id)
    if not profile:
        raise HTTPException(status_code=404, detail="Profile not found")

    # Convert lists to JSON strings for storage
    update_data = profile_in.dict(exclude_unset=True)
    if "traditional_meals" in update_data:
        update_data["traditional_meals"] = str(update_data["traditional_meals"])
    if "dietary_restrictions" in update_data:
        update_data["dietary_restrictions"] = str(update_data["dietary_restrictions"])
    if "favorite_cuisines" in update_data:
        update_data["favorite_cuisines"] = str(update_data["favorite_cuisines"])
    if "disliked_ingredients" in update_data:
        update_data["disliked_ingredients"] = str(update_data["disliked_ingredients"])

    profile = crud.user_profile.update(db, db_obj=profile, obj_in=update_data)
    return profile


@router.post("/family-accounts", response_model=schemas.FamilyAccount)
def create_family_account(
    *,
    db: Session = Depends(deps.get_db),
    account_in: schemas.FamilyAccountCreate,
) -> Any:
    """
    Create new family account.
    """
    account = crud.family_account.create(db, obj_in=account_in)
    return account


@router.post("/family-members", response_model=schemas.FamilyMember)
def create_family_member(
    *,
    db: Session = Depends(deps.get_db),
    member_in: schemas.FamilyMemberCreate,
) -> Any:
    """
    Create new family member.
    """
    member = crud.family_member.create(db, obj_in=member_in)
    return member


@router.get("/family-accounts/{account_id}/members", response_model=List[schemas.FamilyMember])
def read_family_members(
    *,
    db: Session = Depends(deps.get_db),
    account_id: int,
) -> Any:
    """
    Get all family members for a family account.
    """
    members = crud.family_member.get_by_family_account(db, family_account_id=account_id)
    return members
