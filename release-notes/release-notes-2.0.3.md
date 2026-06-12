## CLI::Simple 2.0.3 Release Notes

**New Features**

`CLI::Simple::Utils` adds string case-conversion utilities:

- `toPascalCase` / `ToCamelCase` — convert snake_case or hyphenated
  strings to PascalCase (e.g. `event_bridge` → `EventBridge`).
- `toCamelCase` — same conversion but lowercases the first character
  (e.g. `event_bridge` → `eventBridge`).
- `to_snake_case` — convert CamelCase/PascalCase strings to
  snake_case, handling acronym boundaries (e.g. `HTMLParser` →
  `html_parser`, `UserID` → `user_id`).

All four accept a scalar or arrayref and support both list and hashref
return contexts.
