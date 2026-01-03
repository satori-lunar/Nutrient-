from fastapi import APIRouter

router = APIRouter()

# Placeholder for recipes endpoints
@router.get("/")
def read_recipes():
    return {"message": "Recipes endpoint - coming soon"}
