import random
import string
from typing import Dict

from app.tests.utils.user import create_random_user


def random_lower_string() -> str:
    return "".join(random.choices(string.ascii_lowercase, k=32))


def random_email() -> str:
    return f"{random_lower_string()}@{random_lower_string()}.com"


def random_url() -> str:
    return f"https://{random_lower_string()}.com"
