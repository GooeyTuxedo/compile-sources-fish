#!/usr/bin/env fish

# File: ~/.config/fish/functions/compile_sources.fish
# Function to compile all source code in a directory into a single file

function compile_sources -d "Compile all source code in a directory into a single text file"
    # Process command line arguments
    argparse -n compile_sources 'h/help' -- $argv
    
    if set -q _flag_help
        echo "Usage: compile_sources [source_directory] [output_file]"
        echo ""
        echo "Traverses a directory of source code and generates a single text document."
        echo "Each file is preceded by its relative path and followed by several newlines."
        echo ""
        echo "Options:"
        echo "  source_directory  The directory to traverse (default: current directory)"
        echo "  output_file       The output file to generate (default: source_code_aggregate.txt)"
        return 0
    end
    
    set source_dir "."
    set output_file "source_code_aggregate.txt"
    
    if test (count $argv) -gt 0
        set source_dir $argv[1]
    end
    
    if test (count $argv) -gt 1
        set output_file $argv[2]
    end
    
    # Check if source directory exists
    if not test -d $source_dir
        echo "Error: Source directory '$source_dir' does not exist."
        return 1
    end
    
    # Clear or create output file
    echo -n "" > $output_file
    
    # Get the absolute path of source directory for relative path calculation
    set abs_source_dir (realpath $source_dir)
    
    # Counter for tracking progress
    set total_files 0
    set processed_files 0
    
    # Count total files first
    for file in (find $source_dir -type f | grep -v "\.git/" | sort)
        set total_files (math $total_files + 1)
    end
    
    echo "Found $total_files files to process."
    
    # Process all files
    for file in (find $source_dir -type f | grep -v "\.git/" | sort)
        # Skip binary files and other non-text files
        if file $file | grep -q "binary\|executable\|data"
            continue
        end
        
        # Get the relative path
        set rel_path (string replace -r "^$abs_source_dir/" "./" $file)
        
        # Progress indicator
        set processed_files (math $processed_files + 1)
        printf "Processing file %d/%d: %s\r" $processed_files $total_files $rel_path
        
        # Append file header and content to the output file
        echo "### $rel_path" >> $output_file
        cat $file >> $output_file
        
        # Add several newlines as separator
        echo -e "\n\n\n" >> $output_file
    end
    
    echo -e "\nDone! Generated $output_file with source code from $source_dir"
end
