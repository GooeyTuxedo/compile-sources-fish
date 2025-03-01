#!/usr/bin/env fish

# File: ~/.config/fish/functions/compile_sources.fish
# Function to compile all source code in a directory into a single file

function compile_sources -d "Compile all source code in a directory into a single text file"
    # Process command line arguments
    argparse -n compile_sources 'h/help' 'e/exclude=+' 'i/ignore-file=' -- $argv
    
    if set -q _flag_help
        echo "Usage: compile_sources [source_directory] [output_file]"
        echo ""
        echo "Traverses a directory of source code and generates a single text document."
        echo "Each file is preceded by its relative path and followed by several newlines."
        echo ""
        echo "Options:"
        echo "  -h, --help                  Show this help message"
        echo "  -e, --exclude PATH          Paths to exclude (can be used multiple times)"
        echo "  -i, --ignore-file FILE      Read exclusion patterns from file (e.g., .gitignore)"
        echo ""
        echo "Arguments:"
        echo "  source_directory     The directory to traverse (default: current directory)"
        echo "  output_file          The output file to generate (default: source_code_aggregate.txt)"
        echo ""
        echo "Note: Hidden directories (starting with '.') are skipped by default"
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
    
    # Create a temporary file to hold exclusion patterns
    set temp_exclude_file (mktemp)
    
    # Skip hidden directories by default
    echo "*/.*/*" > $temp_exclude_file
    
    # Add user-specified exclusions
    if set -q _flag_exclude
        for exclude_path in $_flag_exclude
            echo "*$exclude_path*" >> $temp_exclude_file
        end
    end
    
    # Read exclusions from ignore file (like .gitignore)
    if set -q _flag_ignore_file
        set ignore_file $_flag_ignore_file
        
        # Treat the ignore file path as relative to current directory, not source dir
        if test -f $ignore_file
            echo "Reading exclusions from $ignore_file"
            
            # Read and process the ignore file with sed
            # This removes comments, empty lines, and converts patterns to find-compatible format
            sed -e '/^#/d' -e '/^$/d' -e '/^!/d' -e 's/\/$/\/*/' $ignore_file | sed 's/^/\*/' | sed 's/$/\*/' >> $temp_exclude_file
        else
            echo "Warning: Ignore file '$ignore_file' not found."
        end
    end
    
    # Use find with the -not -path option for each exclusion pattern
    set find_args "-type" "f"
    
    # Add each exclusion from the temp file
    for pattern in (cat $temp_exclude_file)
        set -a find_args "-not" "-path" $pattern
    end
    
    # Run the find command and sort results
    set file_list (find $source_dir $find_args | sort)
    
    # Remove temporary exclusion file
    rm $temp_exclude_file
    
    # Count total files
    set total_files (count $file_list)
    echo "Found $total_files files to process."
    
    # Process all files
    set processed_files 0
    
    for file in $file_list
        # Skip binary files, images, audio, video, etc.
        if not file -b --mime-type $file | grep -q "^text/"; and not file -b --mime-type $file | grep -q "application/json"
            # Skip this file but still increment the counter
            set processed_files (math $processed_files + 1)
            printf "Skipping binary file %d/%d: %s\r" $processed_files $total_files $file
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