import 'package:flutter_test/flutter_test.dart';

import 'package:family_helper_flutter/core/realtime/realtime_feature_flags.dart';

void main() {
  test('isMoneyGoalsFeature supports snake_case and legacy camelCase', () {
    expect(isMoneyGoalsFeature('money_goals'), isTrue);
    expect(isMoneyGoalsFeature('moneyGoals'), isTrue);
    expect(isMoneyGoalsFeature('tasks'), isFalse);
  });
}
