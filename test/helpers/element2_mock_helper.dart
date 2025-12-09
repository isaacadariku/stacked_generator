import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer/source/source.dart';

/// Custom mock source that returns a specific URI
class _MockSource implements Source {
  final Uri _uri;

  _MockSource(this._uri);

  @override
  Uri get uri => _uri;

  // Use noSuchMethod to handle all other Source methods we don't need
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} not implemented');
}

/// Custom mock library fragment
class _MockLibraryFragment implements LibraryFragment {
  final Source _source;

  _MockLibraryFragment(this._source);

  @override
  Source get source => _source;

  // Implement other required methods (throwing UnimplementedError for unused ones)
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

/// Custom mock class fragment
class _MockClassFragment implements ClassFragment {
  final LibraryFragment _libraryFragment;

  _MockClassFragment(this._libraryFragment);

  @override
  LibraryFragment get libraryFragment => _libraryFragment;

  // Implement other required methods
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

/// Custom mock ClassElement2
class _MockClassElement2 implements ClassElement2 {
  final ClassFragment _firstFragment;

  _MockClassElement2(this._firstFragment);

  @override
  ClassFragment get firstFragment => _firstFragment;

  // Implement other required methods
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

/// Custom mock for Element2 (enclosing element)
class _MockElement2 implements Element2 {
  final String? _name;

  _MockElement2(this._name);

  @override
  String? get name3 => _name;

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

/// Custom mock for ExecutableFragment
class _MockExecutableFragment implements ExecutableFragment {
  final LibraryFragment _libraryFragment;

  _MockExecutableFragment(this._libraryFragment);

  @override
  LibraryFragment get libraryFragment => _libraryFragment;

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

/// Custom mock for ExecutableElement2
class _MockExecutableElement2 implements ExecutableElement2 {
  final String? _name;
  final Element2? _enclosingElement;
  final ExecutableFragment _firstFragment;

  _MockExecutableElement2(
      this._name, this._enclosingElement, this._firstFragment);

  @override
  String? get name3 => _name;

  @override
  Element2? get enclosingElement2 => _enclosingElement;

  @override
  ExecutableFragment get firstFragment => _firstFragment;

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

/// Creates a mock ClassElement2 for testing Router 2.0 code generation
///
/// [fileName] - The filename to use for the mock element (defaults to 'test_app.dart')
ClassElement2 createMockClassElement2({String fileName = 'test_app.dart'}) {
  // Create the chain from bottom up
  final uri = Uri.parse('package:test_app/lib/$fileName');
  final mockSource = _MockSource(uri);
  final mockLibraryFragment = _MockLibraryFragment(mockSource);
  final mockClassFragment = _MockClassFragment(mockLibraryFragment);
  final mockElement = _MockClassElement2(mockClassFragment);

  return mockElement;
}

/// Creates a mock ExecutableElement2 for testing form field validation
///
/// [methodName] - The name of the method/function
/// [enclosingElementName] - The name of the enclosing class (null if top-level function)
/// [sourceUri] - The source URI string (defaults to 'package:test_app/validators.dart')
ExecutableElement2 createMockExecutableElement2({
  required String methodName,
  String? enclosingElementName,
  String sourceUri = 'package:test_app/validators.dart',
}) {
  // Create the chain from bottom up
  final uri = Uri.parse(sourceUri);
  final mockSource = _MockSource(uri);
  final mockLibraryFragment = _MockLibraryFragment(mockSource);
  final mockExecutableFragment = _MockExecutableFragment(mockLibraryFragment);

  final mockEnclosingElement =
      enclosingElementName != null ? _MockElement2(enclosingElementName) : null;

  final mockElement = _MockExecutableElement2(
    methodName,
    mockEnclosingElement,
    mockExecutableFragment,
  );

  return mockElement;
}
