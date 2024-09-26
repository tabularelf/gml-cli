# gml-cli
 Because why not?

Powered by GMLspeak and [Catspeak](https://github.com/katsaii/catspeak-lang)<br>
Inspired by [gml-cli js version](https://github.com/christopherwk210/gml-cli)

https://github.com/user-attachments/assets/1550344d-9c1b-4072-b28a-0e521d0f9677


Usage:
`gml-cli.exe -s file-goes-here` or `gml-cli.exe -script file-goes-here`

Sandbox is disabled, so should be good for making quick lil GML script test cases or whatever!

# Why?
I thought it'd be a fun idea lol

# What does it support?
I can tell you what it doesn't support! As the list for that is much shorter than what it does.
- Multiline strings
- Template strings
- Static variables 
- Declaring constructor functions 
- "global function" syntax `function func() {}`
- try/catch/finally
- enums
- macros
- exit keyword
- delete keyword (ok it's technically supported but it has bugs so I've disabled it for now)
- Erroring on non-existing variables (right now variables that don't exist return `undefined`... I'll support it in the future)

# Known issues
- GMConsole currently doesn't update the cursor position after execution has ended in powershell (cursed, seriously. I've looked up hundreds of solutions online. It's almost like as if this problem just doesn't exist!)
