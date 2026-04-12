# Responsive Design Guidelines

## Content Width Strategy

On large screens (desktop, wide tablets), UI content must **not** stretch to
fill the full viewport. Input fields, cards, and text become difficult to scan
when they span 2000+ pixels. Instead, content is centered within a maximum
width that preserves readability and touch/click ergonomics.

### Width Constants (`DesignTokens`)

| Token              | Value    | Usage                                          |
|--------------------|----------|-------------------------------------------------|
| `maxContentWidth`  | 1080 px  | Page-level content (lists, dashboards, details) |
| `maxFormWidth`     | 640 px   | Form containers (wizards, create screens)       |
| `maxFieldWidth`    | 480 px   | Individual single-line inputs (text, dropdown)  |

These are defined in `core/theme/design_tokens.dart`.

### Where Constraints Are Applied

1. **Shell level** (`core/navigation/app_shell.dart`):
   `_DesktopShell` wraps the content area in a `Center > ConstrainedBox`
   with `maxContentWidth`. Every screen inherits this constraint.

2. **Form renderer** (`core/widgets/dynamic_form_renderer.dart`):
   The step indicator, section title, field list, and navigation buttons
   are each wrapped in `Center > ConstrainedBox(maxFormWidth)`. This
   keeps form fields at a comfortable phone-like input width.

3. **Entity list pages** (`core/widgets/entity_list_page.dart`):
   Search fields are constrained to `maxFieldWidth` so they don't
   stretch across the full content area on desktop.

4. **Content constraint widget** (`core/widgets/content_constraint.dart`):
   A reusable `ContentConstraint` widget for screens that need explicit
   width control beyond the shell default.

### Rules for New Screens

- **Never** let a single-line text field fill the full content width.
  Wrap it in a `ConstrainedBox(maxWidth: DesignTokens.maxFieldWidth)`.

- **Form steps** should be wrapped in `maxFormWidth`. Use the
  `DynamicFormRenderer` or `FormRequirementWizard` which already handle
  this. For custom forms, wrap the form body in
  `ContentConstraint.form(child: ...)`.

- **Multi-column layouts** (e.g. the form template designer's field
  table + preview) can exceed `maxFormWidth` since they use the space
  productively. They are still bounded by the shell's `maxContentWidth`.

- **Dialogs** should use `SizedBox(width: 400-480)` for create/edit
  dialogs. This is already the convention in the codebase.

- **Grid layouts** (dashboard cards, balance summaries) use
  `LayoutBuilder` with responsive column counts. Cards fill their grid
  cells, which is fine because the grid itself is bounded by the shell's
  `maxContentWidth`.

### Mobile Behavior

On screens narrower than `maxContentWidth`, the constraints have no
effect — content fills the available width normally. The constraints
only activate on desktop/wide-tablet viewports.
