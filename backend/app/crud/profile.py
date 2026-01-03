from typing import Any, Dict, Optional, Union, List

from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.user import UserProfile, FamilyAccount, FamilyMember
from app.schemas.profile import UserProfileCreate, UserProfileUpdate, FamilyAccountCreate, FamilyMemberCreate


class CRUDUserProfile(CRUDBase[UserProfile, UserProfileCreate, UserProfileUpdate]):
    def get_by_user_id(self, db: Session, *, user_id: int) -> Optional[UserProfile]:
        return db.query(UserProfile).filter(UserProfile.user_id == user_id).first()

    def create(self, db: Session, *, obj_in: UserProfileCreate) -> UserProfile:
        # Convert lists to JSON strings for storage
        obj_in_data = obj_in.dict()
        obj_in_data["traditional_meals"] = str(obj_in_data["traditional_meals"])
        obj_in_data["dietary_restrictions"] = str(obj_in_data["dietary_restrictions"])
        obj_in_data["favorite_cuisines"] = str(obj_in_data["favorite_cuisines"])
        obj_in_data["disliked_ingredients"] = str(obj_in_data["disliked_ingredients"])

        db_obj = UserProfile(**obj_in_data)
        db.add(db_obj)
        db.commit()
        db.refresh(db_obj)
        return db_obj


class CRUDFamilyAccount(CRUDBase[FamilyAccount, FamilyAccountCreate, Dict[str, Any]]):
    pass


class CRUDFamilyMember(CRUDBase[FamilyMember, FamilyMemberCreate, Dict[str, Any]]):
    def get_by_family_account(self, db: Session, *, family_account_id: int) -> List[FamilyMember]:
        return db.query(FamilyMember).filter(FamilyMember.family_account_id == family_account_id).all()


user_profile = CRUDUserProfile(UserProfile)
family_account = CRUDFamilyAccount(FamilyAccount)
family_member = CRUDFamilyMember(FamilyMember)
