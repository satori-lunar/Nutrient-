from fastapi import APIRouter

from app.api.api_v1.endpoints import auth, users, profiles, pantry, meal_planning, recipes

api_router = APIRouter()
api_router.include_router(auth.router, prefix="/auth", tags=["authentication"])
api_router.include_router(users.router, prefix="/users", tags=["users"])
api_router.include_router(profiles.router, prefix="/profiles", tags=["profiles"])
api_router.include_router(pantry.router, prefix="/pantry", tags=["pantry"])
api_router.include_router(meal_planning.router, prefix="/meal-planning", tags=["meal-planning"])
api_router.include_router(recipes.router, prefix="/recipes", tags=["recipes"])
