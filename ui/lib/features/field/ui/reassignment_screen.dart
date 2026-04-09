import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_provider.dart';
import '../../../sdk/src/field/v1/field.pb.dart';
import '../data/agent_providers.dart';
import '../data/client_providers.dart';

class ReassignmentScreen extends ConsumerStatefulWidget {
  const ReassignmentScreen({super.key});

  @override
  ConsumerState<ReassignmentScreen> createState() => _ReassignmentScreenState();
}

class _ReassignmentScreenState extends ConsumerState<ReassignmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();

  ClientObject? _selectedClient;
  AgentObject? _selectedAgent;
  String _clientSearchQuery = '';
  String _agentSearchQuery = '';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedClient == null || _selectedAgent == null) return;

    setState(() => _isSubmitting = true);

    try {
      final client = ref.read(fieldServiceClientProvider);
      await client.clientReassign(
        ClientReassignRequest(
          clientId: _selectedClient!.id,
          newAgentId: _selectedAgent!.id,
          reason: _reasonController.text.trim(),
        ),
      );

      // Invalidate client list providers so they refresh
      ref.invalidate(clientListProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Client "${_selectedClient!.name}" reassigned to "${_selectedAgent!.name}" successfully.',
            ),
            backgroundColor: Colors.green,
          ),
        );
        // Reset form
        setState(() {
          _selectedClient = null;
          _selectedAgent = null;
          _reasonController.clear();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reassignment failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final clientsAsync = ref.watch(
      clientListProvider(query: _clientSearchQuery, agentId: ''),
    );
    final agentsAsync = ref.watch(
      agentListProvider(query: _agentSearchQuery, branchId: ''),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Client Reassignment')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Transfer a Client', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 4),
                  Text(
                    'Move a client from their current agent to a new agent.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Client selector
                  Text('Client', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 8),
                  Autocomplete<ClientObject>(
                    displayStringForOption: (client) => client.name,
                    optionsBuilder: (textEditingValue) {
                      final query = textEditingValue.text.trim();
                      if (query != _clientSearchQuery) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            setState(() => _clientSearchQuery = query);
                          }
                        });
                      }
                      return clientsAsync.when(
                        data: (clients) {
                          if (query.isEmpty) return clients;
                          return clients.where(
                            (b) => b.name.toLowerCase().contains(
                              query.toLowerCase(),
                            ),
                          );
                        },
                        loading: () => <ClientObject>[],
                        error: (_, _) => <ClientObject>[],
                      );
                    },
                    onSelected: (client) {
                      setState(() => _selectedClient = client);
                    },
                    fieldViewBuilder:
                        (context, controller, focusNode, onFieldSubmitted) {
                          return TextFormField(
                            controller: controller,
                            focusNode: focusNode,
                            decoration: InputDecoration(
                              hintText: 'Search clients...',
                              prefixIcon: const Icon(Icons.person_search),
                              border: const OutlineInputBorder(),
                              suffixIcon: clientsAsync.isLoading
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
                            validator: (_) {
                              if (_selectedClient == null) {
                                return 'Please select a client';
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) => onFieldSubmitted(),
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
                                final client = options.elementAt(index);
                                return ListTile(
                                  leading: const Icon(Icons.person_outline),
                                  title: Text(client.name),
                                  subtitle: Text('Agent: ${client.agentId}'),
                                  onTap: () => onSelected(client),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  if (_selectedClient != null) ...[
                    const SizedBox(height: 8),
                    _SelectionChip(
                      label: _selectedClient!.name,
                      detail: 'Current agent: ${_selectedClient!.agentId}',
                      icon: Icons.person,
                      onClear: () => setState(() => _selectedClient = null),
                    ),
                  ],
                  const SizedBox(height: 24),

                  // New Agent selector
                  Text('New Agent', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 8),
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
                    },
                    fieldViewBuilder:
                        (context, controller, focusNode, onFieldSubmitted) {
                          return TextFormField(
                            controller: controller,
                            focusNode: focusNode,
                            decoration: InputDecoration(
                              hintText: 'Search agents...',
                              prefixIcon: const Icon(Icons.support_agent),
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
                            validator: (_) {
                              if (_selectedAgent == null) {
                                return 'Please select an agent';
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) => onFieldSubmitted(),
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
                                  leading: const Icon(Icons.support_agent),
                                  title: Text(agent.name),
                                  subtitle: Text(agent.organizationId),
                                  onTap: () => onSelected(agent),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  if (_selectedAgent != null) ...[
                    const SizedBox(height: 8),
                    _SelectionChip(
                      label: _selectedAgent!.name,
                      detail: 'Org: ${_selectedAgent!.organizationId}',
                      icon: Icons.support_agent,
                      onClear: () => setState(() => _selectedAgent = null),
                    ),
                  ],
                  const SizedBox(height: 24),

                  // Reason field
                  Text('Reason', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _reasonController,
                    decoration: const InputDecoration(
                      hintText: 'Provide a reason for this reassignment...',
                      prefixIcon: Icon(Icons.notes),
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Reason is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // Submit button
                  FilledButton.icon(
                    onPressed: _isSubmitting ? null : _submit,
                    icon: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.swap_horiz),
                    label: Text(
                      _isSubmitting ? 'Reassigning...' : 'Reassign Client',
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

class _SelectionChip extends StatelessWidget {
  const _SelectionChip({
    required this.label,
    required this.detail,
    required this.icon,
    required this.onClear,
  });

  final String label;
  final String detail;
  final IconData icon;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withAlpha(80),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.primaryContainer),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  detail,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: onClear,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}
