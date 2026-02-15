import 'package:uuid/uuid.dart';

class OperationId {
  static const Uuid _uuid = Uuid();

  static String next() => _uuid.v4();
}
