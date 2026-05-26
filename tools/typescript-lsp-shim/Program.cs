var cliScript = Path.Combine(
    Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData),
    "npm", "node_modules", "typescript-language-server", "lib", "cli.mjs");

var psi = new System.Diagnostics.ProcessStartInfo
{
    FileName = "node",
    UseShellExecute = false
};
psi.ArgumentList.Add(cliScript);
foreach (var arg in args)
{
    psi.ArgumentList.Add(arg);
}

using var process = System.Diagnostics.Process.Start(psi)!;
process.WaitForExit();
return process.ExitCode;
