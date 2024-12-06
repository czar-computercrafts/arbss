print("Cleaning up all the old files")
shell.execute("rm", "arbss.lua")
shell.execute("rm", "gui.lua")
shell.execute("rm", "peripheralManager.lua")

print("Getting new files")
shell.execute("wget", "https://raw.github.com/czar-computercrafts/arbss/main/arbss.lua")
shell.execute("wget", "https://raw.github.com/czar-computercrafts/arbss/main/guiManager.lua")
shell.execute("wget", "https://raw.github.com/czar-computercrafts/arbss/main/peripheralManager.lua")

print("\nAll Done!\nRun arbss to start, or rename arbss.lua to startup.lua to run whenever the computer resarts!")