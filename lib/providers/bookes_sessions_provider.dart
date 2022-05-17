import 'package:flutter/material.dart';
import 'package:mentcare/models/session_model.dart';
import 'doctors_provider.dart';

import '../models/booked_sessions.dart';

class BookedSessionsProvider with ChangeNotifier {
  final List<BookedSessions> _bookedSessions = [];
}
