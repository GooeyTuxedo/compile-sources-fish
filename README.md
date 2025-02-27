# Installation Instructions for `compile_sources`

To install the `compile_sources` command in Fish shell, follow these steps:

## 1. Create the functions directory (if it doesn't exist)

```fish
mkdir -p ~/.config/fish/functions
```

## 2. Save the function file

Copy the entire function code to `~/.config/fish/functions/compile_sources.fish`:

```fish
# Create the file
nano ~/.config/fish/functions/compile_sources.fish
```

Paste the code and save the file (Ctrl+X, then Y, then Enter).

## 3. Make the file executable

```fish
chmod +x ~/.config/fish/functions/compile_sources.fish
```

## 4. Reload Fish shell or source the function

Either restart your terminal or run:

```fish
source ~/.config/fish/functions/compile_sources.fish
```

## Usage

Now you can use the command as requested:

```fish
# Basic usage with defaults
compile_sources

# With source directory and output file
compile_sources /path/to/source/code output.txt

# Exclude specific paths
compile_sources --exclude node_modules --exclude build /path/to/source output.txt

# Display help
compile_sources --help
```

Note: Hidden directories (those starting with a dot, like `.git`, `.vscode`, etc.) are skipped by default.

## Customizing Further (Optional)

### Add completion support

Create a completion file at `~/.config/fish/completions/compile_sources.fish`:

```fish
# ~/.config/fish/completions/compile_sources.fish
complete -c compile_sources -f -a "(__fish_complete_directories)" -d "Source directory"
complete -c compile_sources -s h -l help -d "Show help message"
complete -c compile_sources -s e -l exclude -r -d "Path to exclude"
```

This will enable directory tab completion when using the command.

### Add to Fish config for system-wide installation

If you want to make this available to all users on your system, you can place the function file in:

```
/usr/share/fish/functions/
```

Note: This requires root permissions.
