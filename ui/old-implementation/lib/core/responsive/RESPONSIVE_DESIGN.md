# Responsive Design Guidelines

## Content Width Strategy

On large screens, UI content fills from the left at a comfortable width.
The remaining space on the right is reserved for contextual panels
(detail views, previews, help) in a master-detail pattern. Input fields
and form containers never stretch to fill the full viewport.

### Width Constants (`DesignTokens`)

| Token              | Value    | Usage                                          |
|--------------------|----------|-------------------------------------------------|
| `maxContentWidth`  | 1080 px  | Page-level content (lists, dashboards, details) |
| `maxFormWidth`     | 640 px   | Form containers (wizards, create screens)       |
| `maxFieldWidth`    | 480 px   | Individual single-line inputs (text, dropdown)  |

Defined in `core/theme/design_tokens.dart`.

### How Constraints Are Applied (Automatic)

Constraints are applied at the theme level — **no per-widget manual
wrapping is needed** for input fields:

1. **Theme level** (`core/theme/app_theme.dart`):
   `InputDecorationTheme.constraints` is set to `maxFieldWidth` on both
   light and dark themes. Every `TextField`, `TextFormField`, and
   `DropdownButtonFormField` inherits this automatically. Fields never
   stretch wider than 480px regardless of parent width.

2. **Shell level** (`core/navigation/app_shell.dart`):
   Content fills naturally from the left. No centering — the desktop
   space to the right of content is available for master-detail views.

3. **Form renderer** (`core/widgets/dynamic_form_renderer.dart`):
   A single top-level `Align(topLeft) + ConstrainedBox(maxFormWidth)`
   wraps the entire form. Not per-field — one constraint on the form.

### Layout Pattern: Left-Aligned with Detail Space

```
┌──────────┬────────────────────────────────┬──────────────────┐
│ Sidebar  │  List / Form (maxFormWidth)    │  Detail Panel    │
│          │  ← left-aligned                │  ← uses the     │
│          │                                │    remaining     │
│          │                                │    space         │
└──────────┴────────────────────────────────┴──────────────────┘
```

When a user clicks an item in a list, the detail view can appear in the
space to the right rather than navigating to a new page. This pattern
is natural for fintech admin tools (table → detail, form → preview).

### Rules for New Screens

- **Do not manually constrain individual fields.** The theme handles it.
- **Do not center content.** Left-align and let the right space be
  available for contextual panels.
- **Form containers** use `ConstrainedBox(maxFormWidth)` once at the
  top level, or `ContentConstraint.form(child: ...)`.
- **Dialogs** use `SizedBox(width: 400-480)`.
- **Grid layouts** use `LayoutBuilder` with responsive column counts.

### Mobile Behavior

On mobile (<600px), constraints have no effect — content fills the
available width normally.
