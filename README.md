# compile_sources

A Fish shell function that traverses a directory of source code and generates a single text document with all source files. This tool is useful for creating documentation, preparing code reviews, or generating inputs for AI code analysis.

## Features

- Recursively processes all text files in a directory structure
- Formats each file with its relative path as a header (`### ./path/to/file.ext`)
- Automatically excludes binary files (images, audio, executables, etc.)
- Skips hidden directories (those starting with `.`) by default
- Supports custom exclusion patterns
- Can use `.gitignore` or similar files for exclusion patterns
- Shows progress while processing

## Installation

1. Create the directory for Fish functions (if it doesn't already exist):
   ```
   mkdir -p ~/.config/fish/functions
   ```

2. Save the function file:
   ```
   # Copy the function code to this location
   cp ./compile_sources.fish ~/.config/fish/functions/compile_sources.fish
   ```

3. Make it executable:
   ```
   chmod +x ~/.config/fish/functions/compile_sources.fish
   ```

4. Reload your Fish shell or run:
   ```
   source ~/.config/fish/functions/compile_sources.fish
   ```

5. (Optional) Set up tab completion by creating a file at `~/.config/fish/completions/compile_sources.fish`:
   ```
   complete -c compile_sources -f -a "(__fish_complete_directories)" -d "Source directory"
   complete -c compile_sources -s h -l help -d "Show help message"
   complete -c compile_sources -s e -l exclude -r -d "Path to exclude"
   complete -c compile_sources -s i -l ignore-file -r -f -a "(__fish_complete_path)" -d "Exclusion patterns file (e.g. .gitignore)"
   ```

## Usage

Basic usage:
```
compile_sources [source_directory] [output_file]
```

### Examples

```fish
# Compile files from current directory to default output file (source_code_aggregate.txt)
compile_sources

# Specify source directory and output file
compile_sources ~/projects/myapp code_review.txt

# Exclude specific directories
compile_sources --exclude node_modules --exclude build

# Use a .gitignore file for exclusions
compile_sources --ignore-file .gitignore

# Combine exclusion methods
compile_sources --ignore-file .gitignore --exclude "temp_*" ~/projects/myapp output.txt

# Get help
compile_sources --help
```

### Output Format

The generated file will contain all source files with headers and spacing:

```
### ./src/main.js
// Source code content here
...


### ./src/utils/helpers.js
// Source code content here
...


### ./src/components/App.jsx
// Source code content here
...
```

## Options

| Option | Description |
|--------|-------------|
| -h, --help | Show help message |
| -e, --exclude PATH | Paths to exclude (can be used multiple times) |
| -i, --ignore-file FILE | Read exclusion patterns from file (e.g., .gitignore) |

## Notes

- The function automatically skips binary files by checking MIME types
- JSON files are treated as text files and included
- Hidden directories (starting with `.`) are skipped by default
- The ignore file is processed relative to the current working directory