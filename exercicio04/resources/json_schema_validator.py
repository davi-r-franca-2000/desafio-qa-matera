import json
from jsonschema import validate, ValidationError
from robot.api import logger


def validate_json_schema(response_text, schema):
    """Validate a JSON response body against a JSON Schema dictionary.

    Raises AssertionError with a descriptive message on validation failure.
    """
    data = json.loads(response_text)
    try:
        validate(instance=data, schema=schema)
    except ValidationError as exc:
        raise AssertionError(
            f"JSON Schema validation failed: {exc.message}\n"
            f"Path: {list(exc.absolute_path)}"
        )
    logger.info("JSON Schema validation passed.")
