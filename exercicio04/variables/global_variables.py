BASE_URL = "https://catfact.ninja"
BREEDS_ENDPOINT = "/breeds"

BREED_SCHEMA = {
    "type": "object",
    "required": [
        "current_page", "data", "first_page_url",
        "from", "last_page", "last_page_url",
        "next_page_url", "path", "per_page", "to", "total"
    ],
    "properties": {
        "current_page": {"type": "integer"},
        "data": {
            "type": "array",
            "items": {
                "type": "object",
                "required": ["breed", "country", "origin", "coat", "pattern"],
                "properties": {
                    "breed": {"type": "string"},
                    "country": {"type": "string"},
                    "origin": {"type": "string"},
                    "coat": {"type": "string"},
                    "pattern": {"type": "string"},
                },
                "additionalProperties": False,
            },
        },
        "first_page_url": {"type": "string"},
        "from": {"type": ["integer", "null"]},
        "last_page": {"type": "integer"},
        "last_page_url": {"type": "string"},
        "links": {
            "type": "array",
            "items": {
                "type": "object",
                "properties": {
                    "url": {"type": ["string", "null"]},
                    "label": {"type": "string"},
                    "active": {"type": "boolean"},
                },
            },
        },
        "next_page_url": {"type": ["string", "null"]},
        "path": {"type": "string"},
        "per_page": {"type": "integer"},
        "prev_page_url": {"type": ["string", "null"]},
        "to": {"type": ["integer", "null"]},
        "total": {"type": "integer"},
    },
}
