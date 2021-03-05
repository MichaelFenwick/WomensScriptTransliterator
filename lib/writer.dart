import 'dart:io';

abstract class Writer {
  const Writer();

  void writeln(Object object);

  void write(Object object);
}

abstract class CloseableWriter extends Writer {
  CloseableWriter();

  void close();
}

class NullWriter extends Writer {
  const NullWriter();

  @override
  void write(Object object) {}

  @override
  void writeln(Object object) {}
}

class StdoutWriter extends Writer {
  const StdoutWriter();

  @override
  void write(Object object) => stdout.write(object);

  @override
  void writeln(Object object) => stdout.writeln(object);
}

class StderrWriter extends Writer {
  const StderrWriter();

  @override
  void write(Object object) => stderr.write(object);

  @override
  void writeln(Object object) => stderr.writeln(object);
}

class FileWriter extends CloseableWriter {
  final String outputFilePath;
  static const String defaultOutputFilePath = 'output_files/output.txt';
  late File _outputFile;
  late IOSink ioSink;

  FileWriter({this.outputFilePath = defaultOutputFilePath}) {
    _outputFile = File(outputFilePath);
    ioSink = _outputFile.openWrite(mode: FileMode.append);
  }

  @override
  void close() => ioSink.close();

  @override
  void write(Object object) => ioSink.write(object);

  @override
  void writeln(Object object) => ioSink.writeln(object);
}
