from typing import List, Optional

from pydantic import BaseModel


class UserProfileBase(BaseModel):
    household_size: int = 1
    num_adults: int = 1
    num_children: int = 0
    zip_code: Optional[str] = None
    city: Optional[str] = None
    state: Optional[str] = None
    country: Optional[str] = None
    weekly_budget: Optional[float] = None
    emergency_mode_budget: Optional[float] = None
    typical_cooking_time: str = "15-30min"
    energy_level_preference: str = "moderate_energy"
    cultural_background: Optional[str] = None
    traditional_meals: List[str] = []
    dietary_restrictions: List[str] = []
    favorite_cuisines: List[str] = []
    disliked_ingredients: List[str] = []
    cooking_skill_level: str = "intermediate"


class UserProfileCreate(UserProfileBase):
    user_id: int


class UserProfileUpdate(UserProfileBase):
    pass


class UserProfile(UserProfileBase):
    id: Optional[int] = None
    user_id: int

    class Config:
        from_attributes = True


class FamilyMemberBase(BaseModel):
    name: str
    age: Optional[int] = None
    relationship: str = "child"
    preferences: List[str] = []
    restrictions: List[str] = []


class FamilyMemberCreate(FamilyMemberBase):
    user_id: int
    family_account_id: int


class FamilyMemberUpdate(FamilyMemberBase):
    pass


class FamilyMember(FamilyMemberBase):
    id: Optional[int] = None
    user_id: int
    family_account_id: int

    class Config:
        from_attributes = True


class FamilyAccountBase(BaseModel):
    name: str


class FamilyAccountCreate(FamilyAccountBase):
    pass


class FamilyAccountUpdate(FamilyAccountBase):
    pass


class FamilyAccount(FamilyAccountBase):
    id: Optional[int] = None
    members: List[FamilyMember] = []

    class Config:
        from_attributes = True
