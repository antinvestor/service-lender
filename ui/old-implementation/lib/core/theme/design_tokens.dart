import 'package:flutter/material.dart';

/// Design tokens from the Stitch "Product-Driven Lending Platform" system.
///
/// These constants encode the "Architectural Fintech Standard" design language:
/// tonal layering, gradient CTAs, ambient shadows, and ghost borders.
abstract final class DesignTokens {
  // ── Primary CTA gradient (135deg, "metallic" weight) ──────────────────────
  static const primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF031632), Color(0xFF1A2B48)],
  );

  // ── Ambient shadow for floating elements ──────────────────────────────────
  static const ambientShadow = BoxShadow(
    color: Color(0x0F081B38),
    blurRadius: 40,
    offset: Offset(0, 20),
  );

  // ── Subtle shadow for cards ───────────────────────────────────────────────
  static const cardShadow = BoxShadow(
    color: Color(0x08081B38),
    blurRadius: 16,
    offset: Offset(0, 4),
  );

  // ── Ghost border (15% opacity outline_variant — "felt, not seen") ─────────
  static Color ghostBorder(BuildContext context) =>
      Theme.of(context).colorScheme.outlineVariant.withAlpha(38);

  // ── Sidebar accent bar width ──────────────────────────────────────────────
  static const accentBarWidth = 4.0;

  // ── Trust Standard radius ─────────────────────────────────────────────────
  static const borderRadius = 8.0;
  static final borderRadiusAll = BorderRadius.circular(borderRadius);

  // ── Content width constraints ────────────────────────────────────────────
  //
  // On large screens, content should not stretch to fill the full viewport.
  // These constraints keep content readable and form fields at a comfortable
  // input width, roughly matching what a user would see on a phone or tablet.
  //
  // maxContentWidth: Maximum width for page-level content (lists, detail
  //   pages, dashboards). Content is centered within the available space
  //   when the viewport exceeds this width.
  //
  // maxFormWidth: Maximum width for form containers. Form fields inside
  //   this constraint remain at a comfortable input size regardless of
  //   how wide the browser window is.
  //
  // maxFieldWidth: Maximum width for individual input fields (text fields,
  //   dropdowns, etc.). Prevents a single-line text field from stretching
  //   across an ultra-wide monitor. Multi-line fields (textarea) can be
  //   wider but still respect maxFormWidth.

  /// Maximum width for page-level content areas.
  static const maxContentWidth = 1080.0;

  /// Maximum width for form containers (wizard steps, create dialogs, etc.).
  static const maxFormWidth = 640.0;

  /// Maximum width for individual single-line input fields.
  static const maxFieldWidth = 480.0;
}
