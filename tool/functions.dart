import 'dart:io';

ProcessResult addFileToCommit(String path) =>
    Process.runSync("git", ["add", path]);
