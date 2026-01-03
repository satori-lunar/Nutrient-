from sqlalchemy import Boolean, Column, Integer, String, DateTime, ForeignKey, Text, Float
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

from app.db.base_class import Base


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True, nullable=False)
    hashed_password = Column(String, nullable=False)
    full_name = Column(String, nullable=False)
    is_active = Column(Boolean, default=True)
    is_superuser = Column(Boolean, default=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationships
    profiles = relationship("UserProfile", back_populates="user", cascade="all, delete-orphan")
    pantry_items = relationship("PantryItem", back_populates="user", cascade="all, delete-orphan")
    meal_plans = relationship("MealPlan", back_populates="user", cascade="all, delete-orphan")


class FamilyAccount(Base):
    __tablename__ = "family_accounts"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    # Relationships
    members = relationship("FamilyMember", back_populates="family_account", cascade="all, delete-orphan")
    shared_meal_plans = relationship("SharedMealPlan", back_populates="family_account", cascade="all, delete-orphan")


class FamilyMember(Base):
    __tablename__ = "family_members"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    family_account_id = Column(Integer, ForeignKey("family_accounts.id"), nullable=False)
    role = Column(String, nullable=False)  # e.g., "primary_cook", "parent", "child"
    joined_at = Column(DateTime(timezone=True), server_default=func.now())

    # Relationships
    user = relationship("User", backref="family_memberships")
    family_account = relationship("FamilyAccount", back_populates="members")


class UserProfile(Base):
    __tablename__ = "user_profiles"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)

    # Household composition
    household_size = Column(Integer, nullable=False, default=1)
    num_adults = Column(Integer, nullable=False, default=1)
    num_children = Column(Integer, nullable=False, default=0)
    primary_cook_id = Column(Integer, ForeignKey("users.id"), nullable=True)

    # Location and budget
    zip_code = Column(String(10), nullable=True)
    city = Column(String, nullable=True)
    state = Column(String, nullable=True)
    country = Column(String, nullable=True)
    weekly_budget = Column(Float, nullable=True)
    emergency_mode_budget = Column(Float, nullable=True)

    # Time and energy capacity
    typical_cooking_time = Column(String, nullable=True)  # "5-10min", "15-30min", "30-60min", "60+min"
    energy_level_preference = Column(String, nullable=True)  # "high_energy", "moderate_energy", "low_energy", "burnout_mode"

    # Cultural background
    cultural_background = Column(Text, nullable=True)
    traditional_meals = Column(Text, nullable=True)  # JSON string of preferred traditional meals
    dietary_restrictions = Column(Text, nullable=True)  # JSON string of restrictions

    # Preferences
    favorite_cuisines = Column(Text, nullable=True)  # JSON string
    disliked_ingredients = Column(Text, nullable=True)  # JSON string
    cooking_skill_level = Column(String, nullable=True)  # "beginner", "intermediate", "advanced"

    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationships
    user = relationship("User", back_populates="profiles")
    primary_cook = relationship("User", foreign_keys=[primary_cook_id])
