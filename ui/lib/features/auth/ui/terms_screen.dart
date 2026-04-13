import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/api/api_provider.dart';
import '../../../core/api/stream_helpers.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../sdk/src/common/v1/common.pb.dart';
import '../../../sdk/src/identity/v1/identity.pb.dart';
import '../../workforce/data/workforce_member_providers.dart';
import '../data/auth_repository.dart';
import '../data/auth_state_provider.dart';

class TermsScreen extends ConsumerStatefulWidget {
  const TermsScreen({super.key});

  @override
  ConsumerState<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends ConsumerState<TermsScreen> {
  bool _accepted = false;
  bool _isSubmitting = false;
  String? _errorMessage;

  Future<void> _handleAccept() async {
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final authRepo = ref.read(authRepositoryProvider);
      final profileId = await authRepo.getCurrentProfileId();
      if (profileId == null || profileId.isEmpty) {
        if (mounted) context.go('/');
        return;
      }

      // Search for the workforce member by profile ID.
      final client = ref.read(identityServiceClientProvider);
      final stream = client.workforceMemberSearch(
        WorkforceMemberSearchRequest(
          query: profileId,
          cursor: PageCursor(limit: 10),
        ),
      );
      final members = await collectStream(
        stream,
        extract: (response) => response.data,
        maxPages: 1,
      );

      final matching = members.where((m) => m.profileId == profileId);
      if (matching.isEmpty) {
        if (mounted) context.go('/');
        return;
      }

      final member = matching.first;

      // Activate the member via the notifier.
      await ref
          .read(workforceMemberProvider.notifier)
          .activate(member.id);

      if (!mounted) return;
      context.go('/');
    } catch (e, stack) {
      AppLogger.error('Failed to accept terms', error: e, stackTrace: stack);
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to accept terms. Please try again.';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _handleDecline() async {
    await ref.read(authStateProvider.notifier).logout();
    if (mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: DesignTokens.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.account_balance,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Terms & Conditions',
                              style: GoogleFonts.manrope(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.3,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Please review and accept to continue',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Scrollable terms content
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerLowest,
                        borderRadius: DesignTokens.borderRadiusAll,
                        border: Border.all(
                          color: DesignTokens.ghostBorder(context),
                        ),
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          _termsContent,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.6,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Error message
                  if (_errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.errorContainer,
                        borderRadius: DesignTokens.borderRadiusAll,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: theme.colorScheme.error,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(
                                color: theme.colorScheme.onErrorContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Checkbox
                  InkWell(
                    onTap: _isSubmitting
                        ? null
                        : () => setState(() => _accepted = !_accepted),
                    borderRadius: DesignTokens.borderRadiusAll,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: _accepted,
                              onChanged: _isSubmitting
                                  ? null
                                  : (v) =>
                                        setState(() => _accepted = v ?? false),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'I have read and accept the Terms & Conditions',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isSubmitting ? null : _handleDecline,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: DesignTokens.borderRadiusAll,
                            ),
                          ),
                          child: const Text('Decline'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 48,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: (_accepted && !_isSubmitting)
                                  ? DesignTokens.primaryGradient
                                  : null,
                              color: (_accepted && !_isSubmitting)
                                  ? null
                                  : theme.colorScheme.outlineVariant,
                              borderRadius: DesignTokens.borderRadiusAll,
                              boxShadow: (_accepted && !_isSubmitting)
                                  ? const [DesignTokens.cardShadow]
                                  : null,
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: (_accepted && !_isSubmitting)
                                    ? _handleAccept
                                    : null,
                                borderRadius: DesignTokens.borderRadiusAll,
                                child: Center(
                                  child: _isSubmitting
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text(
                                          'Accept & Continue',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const _termsContent = '''
TERMS AND CONDITIONS OF SERVICE

Last Updated: April 2026

1. ACCEPTANCE OF TERMS

By accessing and using this platform, you acknowledge that you have read, understood, and agree to be bound by these Terms and Conditions. If you do not agree to these terms, you must not use this platform.

2. WORKFORCE MEMBER RESPONSIBILITIES

As an authorized workforce member, you agree to:

a) Act in good faith and in the best interests of the organization and its clients at all times.

b) Maintain the confidentiality of all client information, account details, and proprietary business data accessed through this platform.

c) Use the platform solely for authorized business purposes and in compliance with all applicable laws, regulations, and organizational policies.

d) Ensure the accuracy and completeness of all data entered into the system, including client information, loan applications, and transaction records.

e) Report any suspected unauthorized access, security breaches, or system irregularities immediately to your supervisor and the system administrator.

3. DATA PROTECTION AND PRIVACY

a) You shall comply with all applicable data protection laws and regulations when handling personal and financial information through this platform.

b) Client data must not be shared with unauthorized third parties, copied to personal devices, or used for any purpose other than the authorized business functions of this platform.

c) You are responsible for safeguarding your login credentials and must not share them with any other person.

4. COMPLIANCE AND REGULATORY OBLIGATIONS

a) You shall adhere to all applicable financial regulations, anti-money laundering (AML) requirements, and know-your-customer (KYC) procedures.

b) All lending activities conducted through this platform must comply with the relevant lending laws and interest rate regulations applicable in your jurisdiction.

c) You acknowledge that your activities on the platform may be audited and monitored for compliance purposes.

5. LIMITATION OF LIABILITY

a) The platform is provided on an "as is" basis. While we strive to maintain system availability and data integrity, we do not guarantee uninterrupted access to the platform.

b) The organization shall not be liable for any losses arising from system downtime, data transmission errors, or unauthorized access resulting from your failure to maintain the security of your credentials.

6. TERMINATION

a) Your access to this platform may be suspended or terminated at any time for violation of these terms, organizational policies, or applicable laws.

b) Upon termination, you must immediately cease all use of the platform and return or destroy any confidential information in your possession.

7. AMENDMENTS

These terms may be updated from time to time. Continued use of the platform after changes are posted constitutes acceptance of the revised terms.

8. GOVERNING LAW

These terms shall be governed by and construed in accordance with the laws of the jurisdiction in which the organization operates.

By accepting these terms, you confirm that you understand your obligations and agree to fulfill them in the course of your duties as an authorized member on this platform.
''';
