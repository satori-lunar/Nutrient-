from sqlalchemy import Boolean, Column, Integer, String, DateTime, ForeignKey, Text, Float, Date
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

from app.db.base_class import Base


class PantryItem(Base):
    __tablename__ = "pantry_items"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    name = Column(String, nullable=False)
    barcode = Column(String, nullable=True)
    quantity = Column(Float, nullable=False, default=1.0)
    unit = Column(String, nullable=False, default="count")  # e.g., "count", "lbs", "oz", "cups"
    category = Column(String, nullable=True)
    expiration_date = Column(Date, nullable=True)
    purchase_date = Column(Date, nullable=True)
    estimated_value = Column(Float, nullable=True)  # Cost per unit
    is_perishable = Column(Boolean, default=True)
    storage_location = Column(String, nullable=True)  # e.g., "pantry", "fridge", "freezer"
    notes = Column(Text, nullable=True)

    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationships
    user = relationship("User", back_populates="pantry_items")
    recipe_matches = relationship("PantryRecipeMatch", back_populates="pantry_item", cascade="all, delete-orphan")


class PantryRecipeMatch(Base):
    __tablename__ = "pantry_recipe_matches"

    id = Column(Integer, primary_key=True, index=True)
    pantry_item_id = Column(Integer, ForeignKey("pantry_items.id"), nullable=False)
    recipe_id = Column(Integer, ForeignKey("recipes.id"), nullable=False)
    missing_ingredients_count = Column(Integer, nullable=False, default=0)
    match_score = Column(Float, nullable=False, default=0.0)  # 0-1 scale
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    # Relationships
    pantry_item = relationship("PantryItem", back_populates="recipe_matches")
    recipe = relationship("Recipe", back_populates="pantry_matches")


class Recipe(Base):
    __tablename__ = "recipes"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    description = Column(Text, nullable=True)
    instructions = Column(Text, nullable=True)
    prep_time_minutes = Column(Integer, nullable=False, default=15)
    cook_time_minutes = Column(Integer, nullable=False, default=30)
    servings = Column(Integer, nullable=False, default=4)
    difficulty = Column(String, nullable=False, default="easy")  # "easy", "medium", "hard"
    cuisine_type = Column(String, nullable=True)
    cultural_background = Column(String, nullable=True)
    is_vegetarian = Column(Boolean, default=False)
    is_vegan = Column(Boolean, default=False)
    is_gluten_free = Column(Boolean, default=False)
    is_dairy_free = Column(Boolean, default=False)

    # Nutrition info (per serving)
    calories = Column(Integer, nullable=True)
    protein_grams = Column(Float, nullable=True)
    carbs_grams = Column(Float, nullable=True)
    fat_grams = Column(Float, nullable=True)

    created_at = Column(DateTime(timezone=True), server_default=func.now())

    # Relationships
    ingredients = relationship("RecipeIngredient", back_populates="recipe", cascade="all, delete-orphan")
    pantry_matches = relationship("PantryRecipeMatch", back_populates="recipe", cascade="all, delete-orphan")
    meal_plan_recipes = relationship("MealPlanRecipe", back_populates="recipe", cascade="all, delete-orphan")


class RecipeIngredient(Base):
    __tablename__ = "recipe_ingredients"

    id = Column(Integer, primary_key=True, index=True)
    recipe_id = Column(Integer, ForeignKey("recipes.id"), nullable=False)
    name = Column(String, nullable=False)
    quantity = Column(Float, nullable=False)
    unit = Column(String, nullable=False)
    is_optional = Column(Boolean, default=False)
    notes = Column(String, nullable=True)

    # Relationships
    recipe = relationship("Recipe", back_populates="ingredients")


class ExpirationAlert(Base):
    __tablename__ = "expiration_alerts"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    pantry_item_id = Column(Integer, ForeignKey("pantry_items.id"), nullable=False)
    alert_type = Column(String, nullable=False)  # "expiring_soon", "expired", "waste_risk"
    days_until_expiration = Column(Integer, nullable=False)
    message = Column(Text, nullable=False)
    is_read = Column(Boolean, default=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    # Relationships
    user = relationship("User", backref="expiration_alerts")
    pantry_item = relationship("PantryItem", backref="expiration_alerts")
