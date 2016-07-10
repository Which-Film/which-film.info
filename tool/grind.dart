import 'package:grinder/grinder.dart';

import 'dart:io';

String chromePath =
    '/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome';

main(args) => grind(args);

@Task('Run tests.')
test() {
  new PubApp.local('test').run([]);
}

@Task('Run tests under Observatory.')
observe_tests() {
  var port = 8181; // The default port, but specifying just to be safe.
  Dart.runAsync(getFile('test/all.dart').path,
      vmArgs: ['--checked', '--observe=${port}']);
  runAsync(chromePath, arguments: ['http://localhost:${port}']);
}

@Task('Analyze code.')
analyze() {
  Analyzer.analyze(existingSourceDirs, fatalWarnings: true);
}

@Task('Verify no formatting changes are required.')
checkFormatting() {
  var status = DartFmt.dryRun(existingSourceDirs);
  exitCode = status ? 1 : 0;
}

@Task('Format all code according to dartfmt.')
format() {
  DartFmt.format(existingSourceDirs);
}

@Task('Everything that should be done as part of CI.')
@Depends(test, analyze, checkFormatting)
ci() {}

@Task('Clean any built files.')
clean() {
  defaultClean();
}

@Task('Build the project for release.')
build() {
  Pub.build(mode: 'release');
}

@Task('Deploy the site.')
@Depends(clean, build)
deploy() {
  run('surge', arguments: ['-d', 'which-film.info', '-p', 'build/web']);
}

@Task('Run in browser.')
browser() {
  try {
    run('dartium', arguments: [
      webDir.absolute.path + '/index.html',
      '--disable-web-security'
    ]);
  } catch (processException) {
    var port = 8080;
    runAsync('pub', arguments: ['serve', '--port=${port}']);
    runAsync(chromePath, arguments: [
      'http://localhost:${port}',
      '--disable-web-security',
      '--user-data-dir',
    ]);
  }
}
