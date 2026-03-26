import 'package:serverpod/serverpod.dart';

class HealthEndpoint extends Endpoint {
  Future<bool> ping(Session session) async {
    return true;
  }
}
