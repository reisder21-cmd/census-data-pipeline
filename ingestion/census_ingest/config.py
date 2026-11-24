"""Settings for Census ACS ingestion. No secrets live in this file."""

import os

from dataclasses import dataclass, field

from dotenv import load_dotenv

BASE_URL = "https://api.census.gov/data"

# Variables from docs/api-exploration.md

VARIABLES = (
    "NAME",
    "B19013_001E", # median household income (estimate)
    "B19013_001M", # median household income (margin of error)
    "B15003_001E", # Total of population age 25+
    "B15003_022E", # Bachelor
    "B15003_023E", # Master's
    "B15003_024E", # Professional Degree
    "B15003_025E", # Doctorate
)

@dataclass(frozen=True)
class Settings:
    api_key: str = field(repr=False) # keeps the key from showing when printing
    year: int
    dataset: str = "acs/acs5"
    variables: tuple[str,...] = VARIABLES
    geography: str = "county:*"

def load_settings(year: int) -> Settings:
    """Build Settings for one vintage, reading the API key from the environment."""
    load_dotenv()
    
    api_key = os.environ.get("CENSUS_API_KEY")
    
    if not api_key:
        raise RuntimeError("CENSUS_API_KEY is not set. Add it to .env in the repo root")
    return Settings(
        api_key=api_key, year=year
    )
