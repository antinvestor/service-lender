import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_provider.dart';
import '../../../core/widgets/state_badge.dart';
import '../../../sdk/src/field/v1/field.pb.dart';
import '../data/agent_providers.dart';

class HierarchyScreen extends ConsumerStatefulWidget {
  const HierarchyScreen({super.key});

  @override
  ConsumerState<HierarchyScreen> createState() => _HierarchyScreenState();
}

class _HierarchyScreenState extends ConsumerState<HierarchyScreen> {
  AgentObject? _selectedAgent;
  String _agentSearchQuery = '';
  int _maxDepth = 0;
  List<AgentObject> _hierarchyNodes = [];
  bool _isLoadingHierarchy = false;
  String? _hierarchyError;

  Future<void> _loadHierarchy() async {
    final agent = _selectedAgent;
    if (agent == null) return;

    setState(() {
      _isLoadingHierarchy = true;
      _hierarchyError = null;
      _hierarchyNodes = [];
    });

    try {
      final client = ref.read(fieldServiceClientProvider);
      final request = AgentHierarchyRequest(
        agentId: agent.id,
        maxDepth: _maxDepth,
      );

      final nodes = <AgentObject>[];
      var pages = 0;
      await for (final response in client.agentHierarchy(request)) {
        nodes.addAll(response.data);
        if (++pages >= 10 || response.data.isEmpty) break;
      }

      if (mounted) {
        setState(() {
          _hierarchyNodes = nodes;
          _isLoadingHierarchy = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hierarchyError = e.toString();
          _isLoadingHierarchy = false;
        });
      }
    }
  }

  String _agentTypeLabel(AgentType type) {
    return switch (type) {
      AgentType.AGENT_TYPE_INDIVIDUAL => 'Individual',
      AgentType.AGENT_TYPE_ORGANIZATION => 'Organization',
      _ => 'Unspecified',
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final agentsAsync = ref.watch(
      agentListProvider(query: _agentSearchQuery, branchId: ''),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Agent Hierarchy')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Agent selector
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Root Agent',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Autocomplete<AgentObject>(
                      displayStringForOption: (agent) => agent.name,
                      optionsBuilder: (textEditingValue) {
                        final query = textEditingValue.text.trim();
                        if (query != _agentSearchQuery) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) {
                              setState(() => _agentSearchQuery = query);
                            }
                          });
                        }
                        return agentsAsync.when(
                          data: (agents) {
                            if (query.isEmpty) return agents;
                            return agents.where(
                              (a) => a.name.toLowerCase().contains(
                                query.toLowerCase(),
                              ),
                            );
                          },
                          loading: () => <AgentObject>[],
                          error: (_, _) => <AgentObject>[],
                        );
                      },
                      onSelected: (agent) {
                        setState(() => _selectedAgent = agent);
                        _loadHierarchy();
                      },
                      fieldViewBuilder:
                          (context, controller, focusNode, onFieldSubmitted) {
                            return TextField(
                              controller: controller,
                              focusNode: focusNode,
                              decoration: InputDecoration(
                                labelText: 'Search agents',
                                hintText: 'Type to search...',
                                prefixIcon: const Icon(Icons.search),
                                border: const OutlineInputBorder(),
                                suffixIcon: agentsAsync.isLoading
                                    ? const Padding(
                                        padding: EdgeInsets.all(12),
                                        child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      )
                                    : null,
                              ),
                              onSubmitted: (_) => onFieldSubmitted(),
                            );
                          },
                      optionsViewBuilder: (context, onSelected, options) {
                        return Align(
                          alignment: Alignment.topLeft,
                          child: Material(
                            elevation: 4,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxHeight: 250,
                                maxWidth: 500,
                              ),
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: options.length,
                                itemBuilder: (context, index) {
                                  final agent = options.elementAt(index);
                                  return ListTile(
                                    leading: const Icon(Icons.person_outline),
                                    title: Text(agent.name),
                                    subtitle: Text(
                                      _agentTypeLabel(agent.agentType),
                                    ),
                                    trailing: StateBadge(state: agent.state),
                                    onTap: () => onSelected(agent),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    // Max depth control
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Max Depth: ${_maxDepth == 0 ? 'Unlimited' : _maxDepth}',
                                style: theme.textTheme.bodyMedium,
                              ),
                              Slider(
                                value: _maxDepth.toDouble(),
                                min: 0,
                                max: 10,
                                divisions: 10,
                                label: _maxDepth == 0
                                    ? 'Unlimited'
                                    : _maxDepth.toString(),
                                onChanged: (value) {
                                  setState(() => _maxDepth = value.round());
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        FilledButton.icon(
                          onPressed:
                              _selectedAgent != null && !_isLoadingHierarchy
                              ? _loadHierarchy
                              : null,
                          icon: const Icon(Icons.account_tree),
                          label: const Text('Load'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Hierarchy tree
            Expanded(child: Card(child: _buildHierarchyContent(theme))),
          ],
        ),
      ),
    );
  }

  Widget _buildHierarchyContent(ThemeData theme) {
    if (_isLoadingHierarchy) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hierarchyError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 12),
              Text(
                'Failed to load hierarchy',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                _hierarchyError!,
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton.tonal(
                onPressed: _loadHierarchy,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_selectedAgent == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.account_tree_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant.withAlpha(100),
            ),
            const SizedBox(height: 16),
            Text(
              'Select an agent to view their hierarchy',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    if (_hierarchyNodes.isEmpty) {
      return Center(
        child: Text(
          'No descendants found',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _hierarchyNodes.length,
      itemBuilder: (context, index) {
        final agent = _hierarchyNodes[index];
        return _HierarchyNodeTile(
          agent: agent,
          agentTypeLabel: _agentTypeLabel(agent.agentType),
        );
      },
    );
  }
}

class _HierarchyNodeTile extends StatelessWidget {
  const _HierarchyNodeTile({required this.agent, required this.agentTypeLabel});

  final AgentObject agent;
  final String agentTypeLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final indentation = agent.depth * 24.0;

    return Padding(
      padding: EdgeInsets.only(
        left: 16 + indentation,
        right: 16,
        top: 2,
        bottom: 2,
      ),
      child: Row(
        children: [
          if (agent.depth > 0) ...[
            Icon(
              Icons.subdirectory_arrow_right,
              size: 18,
              color: theme.colorScheme.onSurfaceVariant.withAlpha(120),
            ),
            const SizedBox(width: 4),
          ],
          Icon(
            agent.agentType == AgentType.AGENT_TYPE_ORGANIZATION
                ? Icons.business
                : Icons.person_outline,
            size: 20,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  agent.name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '$agentTypeLabel  \u2022  Depth ${agent.depth}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          StateBadge(state: agent.state),
        ],
      ),
    );
  }
}
