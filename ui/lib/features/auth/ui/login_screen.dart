import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/auth/tenancy_context.dart';
import '../../../core/config/app_config.dart';
import '../../../core/theme/design_tokens.dart';
import '../data/auth_repository.dart';
import '../data/auth_state_provider.dart';
import '../data/login_target.dart';
import '../data/login_targets_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key, this.initialClientId});

  /// If provided, the login screen auto-navigates to this client_id's level.
  /// Used for entity-scoped login URLs: /login/{client_id}
  final String? initialClientId;

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isLoading = false;
  String? _errorMessage;
  String _filterQuery = '';

  /// Stack of client_ids for drill-down navigation.
  /// Starts with root client_id. Each drill-down pushes the selected target's client_id.
  final List<_BreadcrumbEntry> _navigationStack = [];

  /// The currently selected login target (null = use root client).
  LoginTarget? _selectedTarget;

  String get _currentClientId => _navigationStack.isNotEmpty
      ? _navigationStack.last.clientId
      : AppConfig.oauthClientId;

  @override
  void initState() {
    super.initState();
    // Start at root level
    _navigationStack.add(
      _BreadcrumbEntry(clientId: AppConfig.oauthClientId, name: 'Home'),
    );

    // If an initial client_id was provided via URL, resolve and auto-navigate
    if (widget.initialClientId != null &&
        widget.initialClientId != AppConfig.oauthClientId) {
      _resolveInitialClientId(widget.initialClientId!);
    }
  }

  /// Resolves the initial client_id by fetching its login targets,
  /// then pushes that entity onto the navigation stack so the user
  /// sees the correct org/branch level directly.
  Future<void> _resolveInitialClientId(String clientId) async {
    try {
      final response = await ref.read(loginTargetsProvider(clientId).future);
      if (!mounted) return;

      setState(() {
        _navigationStack.add(
          _BreadcrumbEntry(
            clientId: clientId,
            name: response.currentName.isNotEmpty
                ? response.currentName
                : clientId,
          ),
        );
      });
    } catch (_) {
      // Resolution failed — stay at root, user can navigate manually
    }
  }

  void _drillDown(LoginTarget target) {
    setState(() {
      _navigationStack.add(
        _BreadcrumbEntry(clientId: target.clientId, name: target.name),
      );
      _selectedTarget = null;
      _filterQuery = '';
    });
  }

  void _navigateBack(int index) {
    if (index < _navigationStack.length - 1) {
      setState(() {
        _navigationStack.removeRange(index + 1, _navigationStack.length);
        _selectedTarget = null;
        _filterQuery = '';
      });
    }
  }

  void _selectTarget(LoginTarget target) {
    setState(() {
      _selectedTarget = target;
    });
  }

  StoredLoginContext _buildLoginContext() {
    if (_selectedTarget != null) {
      if (_selectedTarget!.isBranch) {
        // Logging into a specific branch
        // The org context comes from the navigation stack
        final orgEntry = _navigationStack.length > 1
            ? _navigationStack[_navigationStack.length - 1]
            : null;
        return StoredLoginContext(
          level: LoginLevel.branch,
          orgName: orgEntry?.name,
          branchId: _selectedTarget!.clientId,
          branchName: _selectedTarget!.name,
        );
      } else {
        // Selected an org target — logging in at org level
        return StoredLoginContext(
          level: LoginLevel.organization,
          orgName: _selectedTarget!.name,
        );
      }
    }

    // No target selected — logging in at current navigation level
    if (_navigationStack.length > 2) {
      // Navigated into an org — logging at org level
      return StoredLoginContext(
        level: LoginLevel.organization,
        orgName: _navigationStack.last.name,
      );
    }

    return const StoredLoginContext(level: LoginLevel.root);
  }

  Future<void> _handleLogin() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      setState(() {
        _errorMessage =
            'No internet connection. Please connect to the internet and try again.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Determine which client_id to use for login
      final loginClientId = _selectedTarget?.clientId ?? _currentClientId;

      // Store the login context so we can restore tenancy after auth callback
      final loginContext = _buildLoginContext();
      await ref.read(authRepositoryProvider).storeLoginContext(loginContext);

      await ref.read(authStateProvider.notifier).login(clientId: loginClientId);
    } catch (e) {
      var errorMessage = 'Authentication failed. Please try again.';
      final errorStr = e.toString().toLowerCase();

      if (errorStr.contains('socketexception') ||
          errorStr.contains('network is unreachable')) {
        errorMessage =
            'Cannot connect to server. Please check your internet connection.';
      } else if (errorStr.contains('timeout')) {
        errorMessage =
            'Connection timed out. Please check your internet connection.';
      } else if (errorStr.contains('could not launch')) {
        errorMessage =
            'Unable to open web browser. Please check your device settings.';
      } else if (errorStr.contains('oauth error')) {
        final match = RegExp('oauth error: (.+)').firstMatch(errorStr);
        errorMessage = match != null
            ? 'Authentication error: ${match.group(1)}'
            : 'Authentication was denied. Please try again.';
      } else if (errorStr.contains('cancelled') ||
          errorStr.contains('canceled')) {
        errorMessage = 'Authentication was cancelled.';
      }

      if (mounted) {
        setState(() {
          _errorMessage = errorMessage;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final targetsAsync = ref.watch(loginTargetsProvider(_currentClientId));

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Logo & Title ──
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: DesignTokens.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.account_balance,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Ant Investor',
                    style: GoogleFonts.manrope(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Lender Platform',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // ── Breadcrumb navigation ──
                  if (_navigationStack.length > 1) ...[
                    _buildBreadcrumbs(theme),
                    const SizedBox(height: 16),
                  ],

                  // ── Login targets list ──
                  targetsAsync.when(
                    data: (response) => _buildTargetsList(theme, response),
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                    error: (_, _) => _buildTargetsList(
                      theme,
                      const LoginTargetsResponse(
                        targets: [],
                        currentName: '',
                        currentType: 'root',
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Error message ──
                  if (_errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: theme.colorScheme.error,
                          ),
                          const SizedBox(width: 12),
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
                    const SizedBox(height: 16),
                  ],

                  // ── Sign In button ──
                  _buildSignInButton(theme),

                  const SizedBox(height: 24),
                  Text(
                    'By signing in, you agree to our terms of service and privacy policy',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBreadcrumbs(ThemeData theme) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (var i = 0; i < _navigationStack.length; i++) ...[
          if (i > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Icon(
                Icons.chevron_right,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          InkWell(
            onTap: i < _navigationStack.length - 1
                ? () => _navigateBack(i)
                : null,
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Text(
                _navigationStack[i].name,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: i < _navigationStack.length - 1
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                  fontWeight: i == _navigationStack.length - 1
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTargetsList(ThemeData theme, LoginTargetsResponse response) {
    if (response.targets.isEmpty) {
      // No children — user can sign in at this level
      return const SizedBox.shrink();
    }

    final filtered = _filterQuery.isEmpty
        ? response.targets
        : response.targets
              .where(
                (t) =>
                    t.name.toLowerCase().contains(_filterQuery.toLowerCase()) ||
                    t.code.toLowerCase().contains(_filterQuery.toLowerCase()),
              )
              .toList();

    final targetTypeLabel = response.targets.first.isOrganization
        ? 'organization'
        : 'branch';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Search field
        if (response.targets.length > 3)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TextField(
              onChanged: (v) => setState(() => _filterQuery = v),
              decoration: InputDecoration(
                hintText: 'Search ${targetTypeLabel}s...',
                prefixIcon: const Icon(Icons.search, size: 20),
                border: OutlineInputBorder(
                  borderRadius: DesignTokens.borderRadiusAll,
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
            ),
          ),

        Text(
          'Select $targetTypeLabel',
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),

        // Target list
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 280),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final target = filtered[index];
              final isSelected = _selectedTarget?.clientId == target.clientId;
              return _LoginTargetTile(
                target: target,
                isSelected: isSelected,
                onTap: () => _selectTarget(target),
                onDrillDown: target.isOrganization
                    ? () => _drillDown(target)
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSignInButton(ThemeData theme) {
    final loginLabel = _selectedTarget != null
        ? 'Sign in to ${_selectedTarget!.name}'
        : _navigationStack.length > 1
        ? 'Sign in to ${_navigationStack.last.name}'
        : 'Sign In';

    return SizedBox(
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: _isLoading ? null : DesignTokens.primaryGradient,
          color: _isLoading ? theme.colorScheme.outlineVariant : null,
          borderRadius: DesignTokens.borderRadiusAll,
          boxShadow: _isLoading ? null : const [DesignTokens.cardShadow],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _isLoading ? null : _handleLogin,
            borderRadius: DesignTokens.borderRadiusAll,
            child: Center(
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.login, size: 20, color: Colors.white),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            loginLabel,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
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

class _LoginTargetTile extends StatelessWidget {
  const _LoginTargetTile({
    required this.target,
    required this.isSelected,
    required this.onTap,
    this.onDrillDown,
  });

  final LoginTarget target;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onDrillDown;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primaryContainer.withAlpha(100)
            : null,
        borderRadius: DesignTokens.borderRadiusAll,
        border: Border.all(
          color: isSelected
              ? theme.colorScheme.primary.withAlpha(100)
              : theme.colorScheme.outlineVariant.withAlpha(60),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: DesignTokens.borderRadiusAll,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(
                target.isOrganization
                    ? Icons.business_outlined
                    : Icons.store_outlined,
                size: 20,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      target.name,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                    if (target.code.isNotEmpty)
                      Text(
                        target.code,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
              if (onDrillDown != null) ...[
                const SizedBox(width: 4),
                IconButton(
                  onPressed: onDrillDown,
                  icon: Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  tooltip: 'View branches',
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _BreadcrumbEntry {
  const _BreadcrumbEntry({required this.clientId, required this.name});
  final String clientId;
  final String name;
}
