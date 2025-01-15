"""
MIT License

Copyright (c) 2024 Expert Sleepers Ltd

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"""

import sys
import os


def extract_metadata(spn_file):
    """
    Extracts metadata from the .spn file.
    Returns a dictionary with metadata fields.
    """
    metadata = {
        "filename": os.path.basename(spn_file).replace('.spn', ''),
        "pot1": "Pot 1",
        "pot2": "Pot 2",
        "pot3": "Pot 3",
        "title": "",
        "info": "",
    }

    try:
        with open(spn_file, 'r') as F:
            lines = F.readlines()
            lines = [l.strip() for l in lines]

            # Extract title from line 2 if available
            if len(lines) > 1 and lines[1].startswith("; "):
                title = lines[1][2:].strip()
                if title.lower() != "null":
                    metadata["title"] = title

            # Extract pot names from lines 3-5
            for i in range(3):
                if len(lines) > 2 + i and lines[2 + i].startswith(f"; Pot {i}: "):
                    pot_name = lines[2 + i][9:].strip()
                    if pot_name:
                        metadata[f"pot{i+1}"] = pot_name

            # Extract further information from lines 6-7
            description = []
            for i in range(2):
                if len(lines) > 5 + i and lines[5 + i].startswith("; "):
                    description.append(lines[5 + i][2:])
            metadata["info"] = " ".join(description).strip()

    except FileNotFoundError:
        print(f"Error: File '{spn_file}' not found.", file=sys.stderr)
    except Exception as e:
        print(f"Error processing file '{spn_file}': {e}", file=sys.stderr)

    return metadata


def write_txt_file(metadata, output_file):
    """
    Writes metadata to a .txt file in the required format.
    """
    try:
        with open(output_file, 'w') as F:
            F.write(metadata["filename"] + "\n")
            F.write(metadata["pot1"] + "\n")
            F.write(metadata["pot2"] + "\n")
            F.write(metadata["pot3"] + "\n\n")
            F.write(metadata["title"] + "\n\n")
            F.write(metadata["info"] + "\n")
        print(f"Metadata written to '{output_file}'")
    except Exception as e:
        print(f"Error writing to file '{output_file}': {e}", file=sys.stderr)


def process_folder(input_folder):
    """
    Processes all .spn files in the given folder and generates corresponding .txt files.
    """
    if not os.path.isdir(input_folder):
        print(f"Error: '{input_folder}' is not a valid directory.")
        sys.exit(1)

    spn_files = [f for f in os.listdir(input_folder) if f.endswith(".spn")]

    if not spn_files:
        print(f"No .spn files found in '{input_folder}'.")
        return

    for spn_file in spn_files:
        spn_path = os.path.join(input_folder, spn_file)
        txt_path = spn_path.replace(".spn", ".txt")

        # Extract metadata and write the corresponding .txt file
        metadata = extract_metadata(spn_path)
        write_txt_file(metadata, txt_path)


def main():
    if len(sys.argv) < 2:
        print("Usage: python3 script_name.py <input_folder>")
        sys.exit(1)

    input_folder = sys.argv[1]
    process_folder(input_folder)


if __name__ == "__main__":
    main()
