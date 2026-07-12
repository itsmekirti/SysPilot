# Module 1 – Disk Usage Monitoring

# Concept 1 – Shebang (`#!/bin/bash`)

---

# Definition

A **Shebang** is the first line of a script that tells the Linux operating system which interpreter should be used to execute the script.

Example:

```bash
#!/bin/bash
```

This means:

> "Execute this script using the Bash interpreter."

# Syntax

```bash
#!/path/to/interpreter
```

Examples

Use Bash

```bash
#!/bin/bash
```

Use Python

```bash
#!/usr/bin/python3
```

Use Perl

```bash
#!/usr/bin/perl
```

---

# What is an Interpreter?

An interpreter is a program that reads and executes source code line by line.

Think of it as a translator.

```
Bash Script

↓

Bash Interpreter

↓

Linux Kernel

↓

Hardware
```

The Bash interpreter reads every command in the script and asks the Linux kernel to execute it.

---

# Why did we use Shebang in SysPilot?

SysPilot is completely written in Bash.

Therefore, every script begins with

```bash
#!/bin/bash
```

so Linux knows it should execute the file using the Bash interpreter.

---

# What happens when we execute a script?

When we run

```bash
./syswatch.sh
```

Linux performs the following steps:

```
User executes script

↓

Linux opens the file

↓

Reads the first line

↓

#!/bin/bash

↓

Starts the Bash interpreter

↓

Bash reads the script line by line

↓

Commands are executed by the Linux kernel
```

---

# Why is Shebang Important?

Without a Shebang, Linux does not automatically know which interpreter should execute the script.

Example

```bash
echo "Hello"
```

If you run

```bash
./script.sh
```

Linux may fail because no interpreter has been specified.

The Shebang removes this ambiguity.

---

# Do We Always Need a Shebang?

Not always.

If you execute the script like this

```bash
bash syswatch.sh
```

you are explicitly telling Linux to use Bash.

In this case, the Shebang is optional.

However, when executing

```bash
./syswatch.sh
```

the Shebang is considered best practice and should always be included.

---

# Why did we use "./syswatch.sh"?

The symbol

```bash
./
```

means

> Execute a file from the current directory.

So

```bash
./syswatch.sh
```

means

> Run the file named **syswatch.sh** located in the current directory.

---

# Internal Working

```
./syswatch.sh

↓

Linux File System

↓

Read First Line

↓

#!/bin/bash

↓

Launch Bash Interpreter

↓

Execute Script

↓

Output Displayed
```

---
## concept 2: variables
# Definition

A **variable** is a named storage location used to hold data temporarily while a script is running.

Instead of writing the same value multiple times, we store it in a variable and reuse it whenever needed.

Think of a variable as a labeled container.

```
             +----------------------+
Variable --> |      DISK_USAGE      |
             +----------------------+
                         |
                         v
                        45
```

The variable name is **DISK_USAGE**, and its current value is **45**.

---

# Why Do We Need Variables?

Imagine writing a script without variables.

```bash
echo "Disk Usage: 45%"
```

Tomorrow the disk usage becomes 60%.

You would have to edit the script manually.

Instead, we store the value inside a variable.

```bash
DISK_USAGE=45

echo "Disk Usage: $DISK_USAGE%"
```

Now the value changes automatically.

Variables make scripts:

- Dynamic
- Reusable
- Easy to maintain
- Easier to read

---

# Syntax

```bash
VARIABLE_NAME=value
```

Example

```bash
NAME=Kirti
AGE=25
CITY=Noida
```

---

# Variable Naming Rules

## Rule 1

Variable names should begin with a letter or underscore.

Correct

```bash
NAME=Kirti
```

Correct

```bash
_name=Kirti
```

Incorrect

```bash
1NAME=Kirti
```

---

## Rule 2

Spaces are NOT allowed around '='.

Correct

```bash
NAME=Kirti
```

Incorrect

```bash
NAME = Kirti
```

Incorrect

```bash
NAME= Kirti
```

Incorrect

```bash
NAME =Kirti
```

---

## Rule 3

Avoid spaces inside variable names.

Correct

```bash
DISK_USAGE=45
```

Incorrect

```bash
DISK USAGE=45
```

---

## Rule 4

Use meaningful names.

Good

```bash
DISK_USAGE
CPU_USAGE
LOG_FILE
CURRENT_DATE
```

Bad

```bash
A
X
TEMP
ABC
```

---

# How to Access a Variable

To read a variable, use the `$` symbol.

Example

```bash
NAME=Kirti

echo $NAME
```

Output

```
Kirti
```

Without `$`

```bash
echo NAME
```

Output

```
NAME
```

Linux prints the text "NAME" because you did not ask for the variable's value.

---

# Variables in Memory

When Bash executes

```bash
DISK_USAGE=45
```

It stores the value in memory.

```
Memory

+---------------------------+
| DISK_USAGE | 45           |
| LOG_FILE   | logs/sys.log |
| USER        | kirti       |
+---------------------------+
```

Whenever the script needs the value, Bash looks it up in memory.

---

# Variables Used in SysPilot

We created several variables.

### DISK_USAGE

```bash
DISK_USAGE=$(...)
```

Stores the current disk usage percentage.

Example

```
1
```

or

```
85
```

---

### DISK_THRESHOLD

```bash
DISK_THRESHOLD=80
```

Stores the warning threshold.

Later, we moved this value into

```
config/syspilot.conf
```

to avoid hardcoding.

---

### LOG_FILE

```bash
LOG_FILE=../logs/syswatch.log
```

Stores the path of the log file.

Instead of writing

```bash
../logs/syswatch.log
```

multiple times, we store it once in a variable.

If the log location changes in the future, only one line needs to be updated.

---

### CURRENT_DATE

```bash
CURRENT_DATE=$(date "+%Y-%m-%d %H:%M:%S")
```

Stores the current date and time.

---

# Why Did We Use Variables in SysPilot?

Without variables

```bash
echo "Disk Usage: 45%"
```

With variables

```bash
echo "Disk Usage: $DISK_USAGE%"
```

The script automatically adapts to changing system values.

---

# Variable Scope

Variables created inside a function exist only while that function is running.

Example

```bash
check_disk_usage() {

    DISK_USAGE=45

}
```

The variable belongs to that function.


---
# Concept 3 – Command Substitution (`$(...)`)

---

# Definition

**Command Substitution** is a Bash feature that executes a command and stores its output inside a variable or replaces the command with its output.

Instead of storing the command itself, Bash stores the **result** of the command.

---

# Why Do We Need Command Substitution?

Suppose we want to know today's date.

The command is

```bash
date
```

Output

```
Sun Jul 12 10:30:15 PM IST 2026
```

Now imagine we want to use this date multiple times in our script.

Without Command Substitution

```bash
echo $(date)

echo $(date)
```

The command executes every time.

Instead, we execute it once and store the result.

```bash
CURRENT_DATE=$(date)

echo $CURRENT_DATE
echo $CURRENT_DATE
```

This is more efficient and easier to read.

---

# Syntax

```bash
VARIABLE=$(command)
```

General form

```bash
VARIABLE=$(Linux Command)
```

Examples

```bash
CURRENT_USER=$(whoami)

CURRENT_DIRECTORY=$(pwd)

TODAY=$(date)

FILES=$(ls)
```

---

# How Does Command Substitution Work?

Consider

```bash
CURRENT_DATE=$(date)
```

Step 1

Bash sees

```bash
$(date)
```

Step 2

It executes

```bash
date
```

Output

```
Sun Jul 12 10:30:15 PM IST 2026
```

Step 3

Bash replaces

```bash
$(date)
```

with

```
Sun Jul 12 10:30:15 PM IST 2026
```

Step 4

The final statement becomes

```bash
CURRENT_DATE="Sun Jul 12 10:30:15 PM IST 2026"
```

The variable now contains the output of the command.

# Concept 4 – `df -h`

## Definition

`df` stands for **Disk Filesystem**. It displays the disk space usage of all mounted file systems.

The `-h` option means **human-readable**, displaying sizes in KB, MB, GB, etc.

---

## Syntax

```bash
df -h
```

---

## Why We Used It

To check the current disk usage of the Linux system.

---

## Important Columns

| Column | Meaning |
|---------|---------|
| Filesystem | Disk or partition name |
| Size | Total disk size |
| Used | Used storage |
| Avail | Available storage |
| Use% | Percentage of disk used |
| Mounted on | Directory where the filesystem is attached |

---

## SysPilot Usage

```bash
df -h
```

We extracted the **Use%** column because it tells us how much disk space is currently used.

---

## Key Takeaways

- `df` = Disk Filesystem
- `-h` = Human Readable
- We used it to monitor disk usage.

# Concept 5 – `grep`

## Definition

`grep` searches for specific text or patterns from command output or files.

---

## Syntax

```bash
grep pattern
```

Example

```bash
df -h | grep dev
```

---

## Why We Used It

`df -h` returns multiple lines.

We only needed the line containing the actual disk device.

So we filtered the output using

```bash
grep dev
```

---

## SysPilot Usage

```bash
df -h | grep dev
```

---

## Key Takeaways

- Filters unwanted lines.
- Searches for matching text.
- Makes command output easier to process.

# Concept 6 – `awk`

## Definition

`awk` is a text-processing tool used to extract columns from structured output.

---

## Syntax

```bash
awk '{print $5}'
```

---

## Why We Used It

After filtering with `grep`, we only needed the **5th column (Use%)**.

Example

```
Filesystem Size Used Avail Use%
/dev/sdd   1TB   2GB 998GB 1%
```

Here

```
$1 = /dev/sdd
$2 = 1TB
$3 = 2GB
$4 = 998GB
$5 = 1%
```

---

## SysPilot Usage

```bash
awk '{print $5}'
```

---

## Key Takeaways

- `print` displays output.
- `$5` means fifth column.
- Used to extract disk usage percentage.

# Concept 7 – Parameter Expansion

## Definition

Parameter Expansion modifies or manipulates variable values.

---

## Syntax

```bash
${VARIABLE%\%}
```

---

## Why We Used It

Disk usage was

```
1%
```

The `%` symbol must be removed before comparing numbers.

So

```bash
DISK_USAGE=${DISK_USAGE%\%}
```

becomes

```
1
```

---

## Key Takeaways

- `${}` accesses a variable.
- `%` removes matching text from the end.
- `\%` escapes the `%` character.

# Concept 8 – if-else

## Definition

`if-else` is used for decision making.

---

## Syntax

```bash
if [ condition ]
then
    commands
else
    commands
fi
```

---

## Why We Used It

To compare disk usage with the configured threshold.

---

## SysPilot Usage

```bash
if [ $DISK_USAGE -gt $DISK_THRESHOLD ]
then
    ...
else
    ...
fi
```

---

## Key Takeaways

- Executes different code based on a condition.
- `fi` closes the if statement.

# Concept 9 – Comparison Operators

## Common Operators

| Operator | Meaning |
|----------|---------|
| -eq | Equal |
| -ne | Not Equal |
| -gt | Greater Than |
| -lt | Less Than |
| -ge | Greater Than or Equal |
| -le | Less Than or Equal |

---

## Why We Used

```bash
-gt
```

To check whether disk usage exceeded the threshold.

Example

```bash
if [ $DISK_USAGE -gt $DISK_THRESHOLD ]
```

# Concept 10 – Log File

## Definition

A log file stores events generated by an application.

---

## Why We Used It

Instead of printing results only on the terminal, we saved them for future analysis.

---

## SysPilot Usage

```bash
LOG_FILE="../logs/syswatch.log"
```

Writing logs

```bash
echo "Message" >> "$LOG_FILE"
```

---

## Difference

```
>
```

Overwrite file

```
>>
```

Append to file

---

## Key Takeaways

Logs help in monitoring and troubleshooting.

# Concept 11 – Date Command

## Definition

The `date` command displays the current system date and time.

---

## Syntax

```bash
date
```

Formatted output

```bash
date "+%Y-%m-%d %H:%M:%S"
```

---

## Why We Used It

To timestamp every log entry.

---

## SysPilot Usage

```bash
CURRENT_DATE=$(date "+%Y-%m-%d %H:%M:%S")
```

---

## Common Format Specifiers

| Format | Meaning |
|---------|---------|
| %Y | Year |
| %m | Month |
| %d | Day |
| %H | Hour (24-hour) |
| %I | Hour (12-hour) |
| %M | Minutes |
| %S | Seconds |
| %p | AM/PM |

# Concept 12 – Functions

## Definition

A function is a reusable block of code that performs a specific task.

---

## Syntax

```bash
function_name() {

    commands

}
```

Calling

```bash
function_name
```

---

## Why We Used It

To keep the code organized and reusable.

---

## SysPilot Usage

```bash
check_disk_usage() {

}
```

---

## Key Takeaways

One Function = One Responsibility
# Concept 13 – Configuration File

## Definition

A configuration file stores settings separately from the source code.

---

## Why We Used It

Instead of hardcoding

```bash
DISK_THRESHOLD=80
```

we moved it to

```
config/syspilot.conf
```

This allows changing settings without modifying the script.

---

## Example

```bash
DISK_THRESHOLD=80
MEM_THRESHOLD=85
CPU_THRESHOLD=90
```

# Concept 14 – source Command

## Definition

The `source` command executes another file in the current shell.

---

## Syntax

```bash
source filename
```

---

## Why We Used It

To load variables from

```
config/syspilot.conf
```

into our script.

---

## SysPilot Usage

```bash
source ../config/syspilot.conf
```

After sourcing, variables become available automatically.

Example

```bash
echo $DISK_THRESHOLD
```

Output

```
80
```

---

## Key Takeaways

- `source` loads another script or configuration file.
- Variables become available without redefining them.
- Commonly used for configuration management.


