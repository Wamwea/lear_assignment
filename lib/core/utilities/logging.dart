import 'dart:developer';

import 'package:logging/logging.dart';

void setupLogging() {
  Logger.root.onRecord.listen(logRecord);
}

void logRecord(LogRecord record) {
  log(
    '[${record.level.name}] ${record.message}',
    name: record.loggerName,
    sequenceNumber: record.sequenceNumber,
    stackTrace: record.stackTrace,
    error: record.error,
    level: record.level.value,
    zone: record.zone,
  );
}
