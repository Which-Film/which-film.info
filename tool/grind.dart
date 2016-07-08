import 'package:grinder/grinder.dart';

import 'dart:io';

main(args) => grind(args);

@Task('Run tests.')
test() {
  new PubApp.local('test').run([]);
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
  runAsync('pub', arguments: ['serve']);
  try {
    run('dartium', arguments: [
      webDir.absolute.path + '/index.html',
      '--disable-web-security'
    ]);
  } catch (processException) {
    runAsync('/Applications/Google Chrome.app/Contents/MacOS/Google\ Chrome',
        arguments: [
          'http://localhost:8080',
          '--disable-web-security',
          '--user-data-dir',
        ]);
  }
}
