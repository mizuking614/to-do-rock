enum TaskCategory {
  rock,   // 順番ロック制・最重要
  pebble, // 自由順・重要
  sand,   // 自由順・余裕あれば
}

extension TaskCategoryExtension on TaskCategory {
  String get label {
    switch (this) {
      case TaskCategory.rock:
        return 'Rock';
      case TaskCategory.pebble:
        return 'Pebble';
      case TaskCategory.sand:
        return 'Sand';
    }
  }

  String get emoji {
    switch (this) {
      case TaskCategory.rock:
        return '🔒';
      case TaskCategory.pebble:
        return '🪨';
      case TaskCategory.sand:
        return '🏖️';
    }
  }
}
