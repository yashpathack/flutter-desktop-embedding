// Copyright 2018 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the 'License');
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an 'AS IS' BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:io';

/// Runs a [command] on the command line with some logging and error handling
///
/// Takes a [command] and [arguments] to pass to the [command] that will be run
/// on the command line. Stdout and stderr will be printed. An exception
/// thrown if the exit code is not 0 and [allowFail] is false. An optional
/// [workingDirectory] can be passed for the directory of the [command] to be
/// executed in, and [runInShell] can be passed to run the command via a shell.
Future<int> runCommand(String command, List<String> arguments,
    {String workingDirectory,
    bool allowFail = false,
    bool runInShell = false}) async {
  final fullCommand = '$command ${arguments.join(" ")}';
  print('Running $fullCommand');

  final process = await Process.start(command, arguments,
      workingDirectory: workingDirectory, runInShell: runInShell);
  await stdout.addStream(process.stdout);
  await stderr.addStream(process.stderr);

  final exitCode = await process.exitCode;
  if (!allowFail && exitCode != 0) {
    throw new Exception('$fullCommand failed with exit code $exitCode');
  }
  return exitCode;
}
