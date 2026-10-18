/// Action registry for managing conversion actions.

import 'package:citrus/core/models/models.dart';

/// Registry for all available conversion actions.
class ActionRegistry {
  final List<ConversionAction> _actions = [];
  final Map<String, ConversionAction> _actionMap = {};

  /// Register a new action.
  void register(ConversionAction action) {
    if (_actionMap.containsKey(action.id)) {
      throw ArgumentError('Action with id ${action.id} already registered');
    }
    _actions.add(action);
    _actionMap[action.id] = action;
  }

  /// Unregister an action by ID.
  bool unregister(String actionId) {
    final action = _actionMap.remove(actionId);
    if (action != null) {
      _actions.remove(action);
      return true;
    }
    return false;
  }

  /// Get an action by ID.
  ConversionAction? get(String actionId) => _actionMap[actionId];

  /// Get all registered actions.
  List<ConversionAction> get all => List.unmodifiable(_actions);

  /// Get actions compatible with the given file metadata.
  List<ConversionAction> getCompatibleActions(FileMetadata metadata) {
    return _actions.where((action) => action.isCompatible(metadata)).toList();
  }

  /// Get actions compatible with all given file metadata (for batch).
  List<ConversionAction> getCompatibleActionsForBatch(
      List<FileMetadata> metadataList) {
    if (metadataList.isEmpty) return [];

    final compatibleSets = metadataList
        .map((m) =>
            getCompatibleActions(m).where((a) => a.supportsBatch).toSet())
        .toList();

    final intersection = compatibleSets.reduce((a, b) => a.intersection(b));
    return intersection.toList();
  }

  /// Get actions grouped by category.
  Map<ActionCategory, List<ConversionAction>> getActionsByCategory() {
    final map = <ActionCategory, List<ConversionAction>>{};
    for (final category in ActionCategory.values) {
      map[category] = _actions.where((a) => a.category == category).toList();
    }
    return map;
  }

  /// Get actions for a specific category.
  List<ConversionAction> getActionsForCategory(ActionCategory category) {
    return _actions.where((a) => a.category == category).toList();
  }
}

/// Global action registry instance.
final actionRegistry = ActionRegistry();
