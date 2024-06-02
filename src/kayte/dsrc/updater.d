// updater.d
import std.stdio;
import std.process;
import std.datetime;
import std.file;
import std.algorithm;

string repositoryUrl = "https://github.com/your/repo.git";
string cloneDir = "repo_clone";
Duration updateInterval = 10.minutes;

string runCommand(string cmd) {
    string result;
    auto process = pipeShell(cmd, Redirect.stdout | Redirect.stderr);
    process.stdin.close();
    process.stdout.byLineCopy((line) {
        result ~= cast(string)line.idup ~ "\n";
    });
    process.wait();
    return result.strip();
}

void cloneRepository() {
    if (exists(cloneDir)) {
        writeln("Directory ", cloneDir, " already exists. Pulling the latest changes.");
        runCommand("cd " ~ cloneDir ~ " && git pull origin main");
    } else {
        writeln("Cloning ", repositoryUrl, " into ", cloneDir);
        runCommand("git clone " ~ repositoryUrl ~ " " ~ cloneDir);
    }
}

void updateRepository() {
    writeln("Checking for updates...");
    runCommand("cd " ~ cloneDir ~ " && git fetch");
    string status = runCommand("cd " ~ cloneDir ~ " && git status -uno");
    if (status.canFind("Your branch is behind")) {
        writeln("Updates found. Pulling changes...");
        runCommand("cd " ~ cloneDir ~ " && git pull origin main");
        writeln("Repository updated.");
    } else {
        writeln("No updates found.");
    }
}
