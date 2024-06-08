import 'dart:async';
import 'dart:io';

/// A superclass for various classes which specify a mechanism by which output can be written, e.g. writing to the screen or a file. Instances of this class's subclasses can be passed to different components allowing each to write to the same location.
abstract class Writer {
  const Writer();

  void write(Object object);

  void writeln(Object object);
}

/// A superclass for [Writer]s which needs some degree of cleanup after one finishes working with them, e.g. in the case of writing to files or writing into a builder class which needs to build a final object once writing is complete.
abstract class CloseableWriter extends Writer {
  /// A flag to indicate whether or not the Writer has had [close] called on it. Write operations after closing the Writers may not have an effect, and may even produce errors.
  bool _isClosed = false;

  CloseableWriter();

  /// Executes the appropriate cleanup operation once writing is completed. Overrides of this function should set [_isClosed] to true once the cleanup successfully completes.
  FutureOr<void> close() => _isClosed = true;
}

/// A special [Writer] which causes all write operations to be performed as a noop.
class NullWriter extends Writer {
  const NullWriter();

  @override
  void write(Object object) {}

  @override
  void writeln(Object object) {}
}

/// A [Writer] which wil write to the stdout stream.
class StdoutWriter extends Writer {
  const StdoutWriter();

  @override
  void write(Object object) => stdout.write(object);

  @override
  void writeln(Object object) => stdout.writeln(object);
}

/// A [Writer] which wil write to the stderr stream.
class StderrWriter extends Writer {
  const StderrWriter();

  @override
  void write(Object object) => stderr.write(object);

  @override
  void writeln(Object object) => stderr.writeln(object);
}

/// A [CloseableWriter] which will write to the file specified by [outputFilePath]. This will write in append mode, meaning that any existing content in the specified file will be retained.
class FileWriter extends CloseableWriter {
  /// The path of the file to be written to.
  final String outputFilePath;
  late IOSink _ioSink;

  /// A good place to put things if a file path is not specified.
  static const String defaultOutputFilePath = 'output_files/output.txt';

  FileWriter({this.outputFilePath = defaultOutputFilePath}) {
    _ioSink = File(outputFilePath).openWrite(mode: FileMode.append);
  }

  /// Flushes the IOSink to the file and then closes it.
  @override
  Future<void> close() => _ioSink.flush().whenComplete(() => _ioSink.close()).whenComplete(() => _isClosed = true);

  @override
  void write(Object object) => _isClosed ? _ioSink.write(object) : null;

  @override
  void writeln(Object object) => _isClosed ? _ioSink.writeln(object) : null;
}
