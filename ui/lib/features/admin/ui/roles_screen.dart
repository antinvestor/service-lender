import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Data model
// ─────────────────────────────────────────────────────────────────────────────

enum _Entity { organization, branch, agent, client, investor, systemUser }

enum _Action { create, manage, view, reassign }

class _Permission {
  const _Permission(this.entity, this.action);
  final _Entity entity;
  final _Action action;

  @override
  int get hashCode => Object.hash(entity, action);

  @override
  bool operator ==(Object other) =>
      other is _Permission && other.entity == entity && other.action == action;
}

// ─────────────────────────────────────────────────────────────────────────────
// Static permission matrix (mirrors backend authz/constants.go)
// ─────────────────────────────────────────────────────────────────────────────

const _allPermissions = [
  _Permission(_Entity.organization, _Action.manage),
  _Permission(_Entity.organization, _Action.view),
  _Permission(_Entity.branch, _Action.manage),
  _Permission(_Entity.branch, _Action.view),
  _Permission(_Entity.agent, _Action.create),
  _Permission(_Entity.agent, _Action.manage),
  _Permission(_Entity.agent, _Action.view),
  _Permission(_Entity.client, _Action.create),
  _Permission(_Entity.client, _Action.manage),
  _Permission(_Entity.client, _Action.view),
  _Permission(_Entity.client, _Action.reassign),
  _Permission(_Entity.investor, _Action.create),
  _Permission(_Entity.investor, _Action.manage),
  _Permission(_Entity.investor, _Action.view),
  _Permission(_Entity.systemUser, _Action.manage),
  _Permission(_Entity.systemUser, _Action.view),
];

final Set<_Permission> _allSet = _allPermissions.toSet();

final Map<String, Set<_Permission>> _rolePermissions = {
  'Owner': _allSet,
  'Admin': _allSet,
  'Manager': {
    const _Permission(_Entity.branch, _Action.view),
    const _Permission(_Entity.agent, _Action.create),
    const _Permission(_Entity.agent, _Action.manage),
    const _Permission(_Entity.agent, _Action.view),
    const _Permission(_Entity.client, _Action.create),
    const _Permission(_Entity.client, _Action.manage),
    const _Permission(_Entity.client, _Action.view),
    const _Permission(_Entity.client, _Action.reassign),
    const _Permission(_Entity.systemUser, _Action.view),
  },
  'Agent': {
    const _Permission(_Entity.agent, _Action.view),
    const _Permission(_Entity.client, _Action.create),
    const _Permission(_Entity.client, _Action.view),
  },
  'Verifier': {
    const _Permission(_Entity.branch, _Action.view),
    const _Permission(_Entity.agent, _Action.view),
    const _Permission(_Entity.client, _Action.view),
    const _Permission(_Entity.investor, _Action.view),
  },
  'Approver': {
    const _Permission(_Entity.branch, _Action.view),
    const _Permission(_Entity.agent, _Action.view),
    const _Permission(_Entity.client, _Action.view),
    const _Permission(_Entity.investor, _Action.view),
  },
  'Auditor': {
    const _Permission(_Entity.organization, _Action.view),
    const _Permission(_Entity.branch, _Action.view),
    const _Permission(_Entity.agent, _Action.view),
    const _Permission(_Entity.client, _Action.view),
    const _Permission(_Entity.investor, _Action.view),
    const _Permission(_Entity.systemUser, _Action.view),
  },
  'Viewer': {
    const _Permission(_Entity.organization, _Action.view),
    const _Permission(_Entity.branch, _Action.view),
    const _Permission(_Entity.agent, _Action.view),
    const _Permission(_Entity.client, _Action.view),
    const _Permission(_Entity.investor, _Action.view),
    const _Permission(_Entity.systemUser, _Action.view),
  },
  'Service': _allSet,
};

// Column groups for the header row
const _entityColumns = <(_Entity, List<_Action>)>[
  (_Entity.organization, [_Action.manage, _Action.view]),
  (_Entity.branch, [_Action.manage, _Action.view]),
  (_Entity.agent, [_Action.create, _Action.manage, _Action.view]),
  (
    _Entity.client,
    [_Action.create, _Action.manage, _Action.view, _Action.reassign],
  ),
  (_Entity.investor, [_Action.create, _Action.manage, _Action.view]),
  (_Entity.systemUser, [_Action.manage, _Action.view]),
];

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────

String _entityLabel(_Entity e) => switch (e) {
  _Entity.organization => 'Organization',
  _Entity.branch => 'Branch',
  _Entity.agent => 'Agent',
  _Entity.client => 'Client',
  _Entity.investor => 'Investor',
  _Entity.systemUser => 'System User',
};

String _actionLabel(_Action a) => switch (a) {
  _Action.create => 'Create',
  _Action.manage => 'Manage',
  _Action.view => 'View',
  _Action.reassign => 'Reassign',
};

// ─────────────────────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────────────────────

class RolesScreen extends StatelessWidget {
  const RolesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 700;
        final padding = isNarrow ? 16.0 : 24.0;

        return CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(padding, padding, padding, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Roles & Permissions',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Overview of the permission matrix for each system role.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withAlpha(140),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Legend
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(padding, 12, padding, 4),
                child: Row(
                  children: [
                    Icon(Icons.check, size: 16, color: colorScheme.primary),
                    const SizedBox(width: 4),
                    Text(
                      'Granted',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withAlpha(160),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      '\u2014',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withAlpha(60),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Not granted',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withAlpha(160),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Permission matrix table
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: _PermissionTable(theme: theme),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Permission table widget
// ─────────────────────────────────────────────────────────────────────────────

class _PermissionTable extends StatelessWidget {
  const _PermissionTable({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final colorScheme = theme.colorScheme;
    final roles = _rolePermissions.keys.toList();
    final borderColor = colorScheme.outlineVariant.withAlpha(80);

    return Table(
      defaultColumnWidth: const IntrinsicColumnWidth(),
      border: TableBorder(
        horizontalInside: BorderSide(color: borderColor, width: 1),
        verticalInside: BorderSide(color: borderColor, width: 1),
      ),
      children: [
        // Entity group header row
        _buildEntityGroupRow(colorScheme, borderColor),
        // Action sub-header row
        _buildActionHeaderRow(colorScheme),
        // Data rows
        for (var i = 0; i < roles.length; i++)
          _buildDataRow(
            roles[i],
            _rolePermissions[roles[i]]!,
            colorScheme,
            isEven: i.isEven,
          ),
      ],
    );
  }

  TableRow _buildEntityGroupRow(ColorScheme colorScheme, Color borderColor) {
    final cells = <Widget>[
      // Empty cell for the role name column
      _headerCell('', colorScheme, isGroupHeader: true),
    ];

    for (final (entity, actions) in _entityColumns) {
      cells.add(
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          color: colorScheme.surfaceContainerHighest.withAlpha(80),
          child: Center(
            child: Text(
              _entityLabel(entity),
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      );

      // Add empty cells for remaining columns in the group (merged visually)
      for (var j = 1; j < actions.length; j++) {
        cells.add(
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            color: colorScheme.surfaceContainerHighest.withAlpha(80),
          ),
        );
      }
    }

    return TableRow(children: cells);
  }

  TableRow _buildActionHeaderRow(ColorScheme colorScheme) {
    final cells = <Widget>[
      Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        color: colorScheme.surfaceContainerHighest.withAlpha(40),
        child: Text(
          'Role',
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface.withAlpha(180),
          ),
        ),
      ),
    ];

    for (final (_, actions) in _entityColumns) {
      for (final action in actions) {
        cells.add(
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            color: colorScheme.surfaceContainerHighest.withAlpha(40),
            child: Center(
              child: Text(
                _actionLabel(action),
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface.withAlpha(140),
                  fontSize: 11,
                ),
              ),
            ),
          ),
        );
      }
    }

    return TableRow(children: cells);
  }

  TableRow _buildDataRow(
    String roleName,
    Set<_Permission> granted,
    ColorScheme colorScheme, {
    required bool isEven,
  }) {
    final bgColor = isEven
        ? Colors.transparent
        : colorScheme.surfaceContainerHighest.withAlpha(25);

    final cells = <Widget>[
      Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        color: bgColor,
        child: Text(
          roleName,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ];

    for (final (entity, actions) in _entityColumns) {
      for (final action in actions) {
        final hasPermission = granted.contains(_Permission(entity, action));
        cells.add(
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            color: bgColor,
            child: Center(
              child: hasPermission
                  ? Icon(Icons.check, size: 18, color: colorScheme.primary)
                  : Text(
                      '\u2014',
                      style: TextStyle(
                        color: colorScheme.onSurface.withAlpha(50),
                        fontSize: 14,
                      ),
                    ),
            ),
          ),
        );
      }
    }

    return TableRow(children: cells);
  }

  Widget _headerCell(
    String text,
    ColorScheme colorScheme, {
    bool isGroupHeader = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      color: colorScheme.surfaceContainerHighest.withAlpha(80),
      child: Text(
        text,
        style: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }
}
