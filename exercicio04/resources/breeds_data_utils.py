"""Desafio Adicional (Opcao C) – Manipulacao de Strings/Listas da Resposta.

Biblioteca Python customizada que expoe keywords para o Robot Framework
permitindo filtrar, formatar e agregar dados da lista de breeds retornada
pelo endpoint GET /breeds da Cat Facts API.
"""

from collections import Counter

from robot.api import logger


def filter_breeds_by_field(data, field, value):
    """Return breeds whose *field* matches *value* (case-insensitive).

    Raises ``AssertionError`` when no breeds match the filter criteria.
    """
    filtered = [
        breed for breed in data
        if breed.get(field, "").strip().lower() == value.strip().lower()
    ]
    logger.info(
        f"Filtered {len(filtered)}/{len(data)} breeds "
        f"where '{field}' == '{value}'"
    )
    if not filtered:
        raise AssertionError(
            f"No breeds found with {field}='{value}'. "
            f"Available values: {sorted({b.get(field) for b in data})}"
        )
    return filtered


def get_breed_names_sorted(data):
    """Return breed names sorted in ascending alphabetical order."""
    names = sorted(breed["breed"] for breed in data)
    logger.info(f"Sorted {len(names)} breed names alphabetically")
    return names


def get_unique_values(data, field):
    """Return a sorted list of unique values for *field*."""
    values = sorted({breed.get(field, "") for breed in data})
    logger.info(f"Found {len(values)} unique values for '{field}': {values}")
    return values


def format_breed_names_upper(data):
    """Return all breed names converted to uppercase."""
    names = [breed["breed"].upper() for breed in data]
    logger.info(f"Formatted {len(names)} breed names to uppercase")
    return names


def count_breeds_by_field(data, field):
    """Return a dictionary mapping each unique *field* value to its count."""
    counts = dict(Counter(breed.get(field, "") for breed in data))
    logger.info(f"Breed counts by '{field}': {counts}")
    return counts
