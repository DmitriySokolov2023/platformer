import os
import glob

def combine_haskell_files(output_file="combined.hs"):
    with open(output_file, 'w', encoding='utf-8') as outfile:
        # Найти все .hs файлы
        hs_files = glob.glob('**/*.hs', recursive=True)
        
        for filepath in hs_files:
            # Пропустить выходной файл, если он уже существует
            if filepath == output_file:
                continue
                
            outfile.write(f"\n\n-- {'='*60}\n")
            outfile.write(f"-- Файл: {filepath}\n")
            outfile.write(f"-- {'='*60}\n\n")
            
            with open(filepath, 'r', encoding='utf-8') as infile:
                outfile.write(infile.read())
                outfile.write("\n")

if __name__ == "__main__":
    combine_haskell_files()