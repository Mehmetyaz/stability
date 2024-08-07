part of '../stability_base.dart';

/// Ensures that the given value is a correct cfg_scale value.
void ensureCfgScale(double? cfgScale) {
  if (cfgScale != null && (cfgScale < 0 || cfgScale > 35)) {
    throw ArgumentError.value(
        cfgScale, "cfgScale", "cfgScale must be between 1 and 4, inclusive");
  }
}

/// Ensures that the given value minimum is at least [min].
void ensureMin(num? value, num min, String field) {
  if (value != null && value < min) {
    throw ArgumentError.value(value, field, "must be at least $min");
  }
}

/// Ensures that the given value maximum is at most [max].
void ensureMax(num? value, num max, String field) {
  if (value != null && value > max) {
    throw ArgumentError.value(value, field, "must be at most $max");
  }
}

/// Ensures that the given value is within the range [min] and [max].
void ensureRange(num? value, num min, num max, String field) {
  ensureMin(value, min, field);
  ensureMax(value, max, field);
}

/// Ensures that the given value is divisible by [divisor].
void ensureDivisibleBy(int? value, int divisor, String field) {
  if (value != null && value % divisor != 0) {
    throw ArgumentError.value(value, field, "must be divisible by $divisor");
  }
}
