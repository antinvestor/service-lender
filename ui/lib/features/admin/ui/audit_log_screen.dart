import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/audit_trail_widget.dart';
import '../../../sdk/src/loans/v1/loans.pb.dart';
import '../../../sdk/src/loans/v1/loans.pbenum.dart';
import '../data/audit_log_providers.dart';

class AuditLogScreen extends ConsumerStatefulWidget {
  const AuditLogScreen({super.key});

  @override
  ConsumerState<AuditLogScreen> createState() => _AuditLogScreenState();
}

class _AuditLogScreenState extends ConsumerState<AuditLogScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) {
        setState(() {
          _searchQuery = value.trim();
        });
      }
    });
  }

  String _loanStatusName(int statusValue) {
    final status = LoanStatus.valueOf(statusValue);
    if (status == null) return 'Unknown ($statusValue)';
    return switch (status) {
      LoanStatus.LOAN_STATUS_PENDING_DISBURSEMENT => 'Pending Disbursement',
      LoanStatus.LOAN_STATUS_ACTIVE => 'Active',
      LoanStatus.LOAN_STATUS_DELINQUENT => 'Delinquent',
      LoanStatus.LOAN_STATUS_DEFAULT => 'Default',
      LoanStatus.LOAN_STATUS_PAID_OFF => 'Paid Off',
      LoanStatus.LOAN_STATUS_RESTRUCTURED => 'Restructured',
      LoanStatus.LOAN_STATUS_WRITTEN_OFF => 'Written Off',
      LoanStatus.LOAN_STATUS_CLOSED => 'Closed',
      _ => 'Unspecified',
    };
  }

  List<LoanStatusChangeObject> _filterEntries(
    List<LoanStatusChangeObject> entries,
  ) {
    if (_searchQuery.isEmpty) return entries;
    final q = _searchQuery.toLowerCase();
    return entries.where((e) {
      return e.loanAccountId.toLowerCase().contains(q) ||
          e.id.toLowerCase().contains(q) ||
          e.changedBy.toLowerCase().contains(q) ||
          e.reason.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entriesAsync = ref.watch(loanStatusChangeListProvider());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Row(
            children: [
              Icon(Icons.history_outlined,
                  size: 28, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Audit Log',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh',
                onPressed: () =>
                    ref.invalidate(loanStatusChangeListProvider()),
              ),
            ],
          ),
        ),

        // Search bar
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
          child: TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search by loan ID, user, or reason...',
              prefixIcon: const Icon(Icons.search, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: theme.colorScheme.outlineVariant),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: theme.colorScheme.outlineVariant),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              isDense: true,
            ),
          ),
        ),

        // Content
        Expanded(
          child: entriesAsync.when(
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline,
                      size: 48, color: theme.colorScheme.error),
                  const SizedBox(height: 16),
                  Text('Failed to load audit log: $error',
                      style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 16),
                  FilledButton.tonal(
                    onPressed: () =>
                        ref.invalidate(loanStatusChangeListProvider()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            data: (entries) {
              final filtered = _filterEntries(entries);

              if (filtered.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer
                              .withAlpha(60),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.history_outlined,
                          size: 28,
                          color:
                              theme.colorScheme.primary.withAlpha(160),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _searchQuery.isNotEmpty
                            ? 'No matching entries found'
                            : 'No audit entries yet',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withAlpha(140),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 8),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final entry = filtered[index];
                  final fromLabel =
                      _loanStatusName(entry.fromStatus);
                  final toLabel = _loanStatusName(entry.toStatus);

                  return AuditTrailEntry(
                    action: '$fromLabel \u2192 $toLabel',
                    timestamp: entry.changedAt.isNotEmpty
                        ? entry.changedAt
                        : '--',
                    performedBy: entry.changedBy.isNotEmpty
                        ? entry.changedBy
                        : null,
                    reason: entry.reason.isNotEmpty
                        ? entry.reason
                        : null,
                    icon: Icons.swap_horiz,
                    details: {
                      'Entity': 'Loan Account',
                      'Loan ID': entry.loanAccountId.isNotEmpty
                          ? entry.loanAccountId
                          : entry.id,
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
