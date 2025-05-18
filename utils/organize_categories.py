#!/usr/bin/env python3
import json
import os
import shutil
from pathlib import Path

def organize_pages():
    pages_dir = Path('pages')
    
    # Get all JSON files in the pages directory
    json_files = list(pages_dir.glob('*.json'))
    
    # Create category directories and move files
    for json_file in json_files:
        if json_file.name == '.gitkeep':
            continue
            
        with open(json_file) as f:
            try:
                data = json.load(f)
                category = data.get('category', 'uncategorized')
                
                # Create sanitized category name for directory
                category_dir = category.lower().replace(' ', '-')
                category_path = pages_dir / category_dir
                
                # Create category directory if it doesn't exist
                category_path.mkdir(exist_ok=True)
                
                # Move the file to its category directory
                new_path = category_path / json_file.name
                if not new_path.exists():  # Only move if not already there
                    shutil.move(str(json_file), str(new_path))
                    print(f"Moved {json_file.name} to {category_dir}/")
                
            except json.JSONDecodeError:
                print(f"Error: {json_file} is not a valid JSON file")
                continue

if __name__ == '__main__':
    organize_pages() 