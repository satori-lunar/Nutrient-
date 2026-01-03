from sqlalchemy import Boolean, Column, Integer, String, DateTime, ForeignKey, Text, Float, Date, JSON
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

from app.db.base_class import Base


class MealPlan(Base):
    __tablename__ = "meal_plans"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    name = Column(String, nullable=False)
    start_date = Column(Date, nullable=False)
    end_date = Column(Date, nullable=False)
    budget_limit = Column(Float, nullable=True)
    total_estimated_cost = Column(Float, nullable=True)
    is_active = Column(Boolean, default=True)
    preferences = Column(JSON, nullable=True)  # Store user preferences as JSON

    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationships
    user = relationship("User", back_populates="meal_plans")
    recipes = relationship("MealPlanRecipe", back_populates="meal_plan", cascade="all, delete-orphan")
    shopping_lists = relationship("ShoppingList", back_populates="meal_plan", cascade="all, delete-orphan")


class MealPlanRecipe(Base):
    __tablename__ = "meal_plan_recipes"

    id = Column(Integer, primary_key=True, index=True)
    meal_plan_id = Column(Integer, ForeignKey("meal_plans.id"), nullable=False)
    recipe_id = Column(Integer, ForeignKey("recipes.id"), nullable=False)
    scheduled_date = Column(Date, nullable=False)
    meal_type = Column(String, nullable=False)  # "breakfast", "lunch", "dinner", "snack"
    servings = Column(Integer, nullable=False, default=4)
    is_alternative = Column(Boolean, default=False)  # If this is an alternative to original recipe
    notes = Column(Text, nullable=True)

    # Relationships
    meal_plan = relationship("MealPlan", back_populates="recipes")
    recipe = relationship("Recipe", back_populates="meal_plan_recipes")


class SharedMealPlan(Base):
    __tablename__ = "shared_meal_plans"

    id = Column(Integer, primary_key=True, index=True)
    family_account_id = Column(Integer, ForeignKey("family_accounts.id"), nullable=False)
    original_meal_plan_id = Column(Integer, ForeignKey("meal_plans.id"), nullable=False)
    shared_by_user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    name = Column(String, nullable=False)
    start_date = Column(Date, nullable=False)
    end_date = Column(Date, nullable=False)
    is_active = Column(Boolean, default=True)

    created_at = Column(DateTime(timezone=True), server_default=func.now())

    # Relationships
    family_account = relationship("FamilyAccount", back_populates="shared_meal_plans")
    original_meal_plan = relationship("MealPlan", backref="shared_versions")


class ShoppingList(Base):
    __tablename__ = "shopping_lists"

    id = Column(Integer, primary_key=True, index=True)
    meal_plan_id = Column(Integer, ForeignKey("meal_plans.id"), nullable=False)
    store_name = Column(String, nullable=True)
    store_location = Column(String, nullable=True)
    total_estimated_cost = Column(Float, nullable=True)
    is_completed = Column(Boolean, default=False)

    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationships
    meal_plan = relationship("MealPlan", back_populates="shopping_lists")
    items = relationship("ShoppingListItem", back_populates="shopping_list", cascade="all, delete-orphan")


class ShoppingListItem(Base):
    __tablename__ = "shopping_list_items"

    id = Column(Integer, primary_key=True, index=True)
    shopping_list_id = Column(Integer, ForeignKey("shopping_lists.id"), nullable=False)
    name = Column(String, nullable=False)
    quantity = Column(Float, nullable=False)
    unit = Column(String, nullable=False)
    estimated_price = Column(Float, nullable=True)
    category = Column(String, nullable=True)
    is_purchased = Column(Boolean, default=False)
    alternative_suggestions = Column(JSON, nullable=True)  # Store cheaper alternatives as JSON

    # Relationships
    shopping_list = relationship("ShoppingList", back_populates="items")


class NutritionLog(Base):
    __tablename__ = "nutrition_logs"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    family_account_id = Column(Integer, ForeignKey("family_accounts.id"), nullable=True)
    date = Column(Date, nullable=False)
    meal_type = Column(String, nullable=False)  # "breakfast", "lunch", "dinner", "snack"
    recipe_id = Column(Integer, ForeignKey("recipes.id"), nullable=True)
    custom_meal_name = Column(String, nullable=True)

    # Nutrition data
    calories = Column(Integer, nullable=True)
    protein_grams = Column(Float, nullable=True)
    carbs_grams = Column(Float, nullable=True)
    fat_grams = Column(Float, nullable=True)

    # Family context
    family_member_name = Column(String, nullable=True)  # If tracking for specific family member
    notes = Column(Text, nullable=True)

    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationships
    user = relationship("User", backref="nutrition_logs")
    recipe = relationship("Recipe", backref="nutrition_logs")
