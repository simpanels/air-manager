import os
import shutil
import zipfile

# This script extracts each .siff file into a 'source' folder so you may view the source code / any changes.

def main():
    # Walk through the directory tree
    for root, dirs, files in os.walk(".", topdown=False):
        # Remove any folder named 'source'
        for dir_name in dirs:
            if dir_name == "source":
                source_path = os.path.join(root, dir_name)
                print(f"Removing folder: {source_path}")
                shutil.rmtree(source_path)

        # Process .siff files
        for file_name in files:
            if file_name.endswith(".siff"):
                siff_path = os.path.join(root, file_name)
                zip_path = siff_path.replace(".siff", ".zip")
                source_folder = os.path.join(root, "source")
                
                # Copy .siff to .zip
                shutil.copy2(siff_path, zip_path)
                print(f"Copied {siff_path} to {zip_path}")

                # Create the source folder if it doesn't exist
                os.makedirs(source_folder, exist_ok=True)

                # Extract .zip into 'source' folder
                with zipfile.ZipFile(zip_path, 'r') as zip_ref:
                    zip_ref.extractall(source_folder)
                    print(f"Extracted {zip_path} to {source_folder}")

                # Remove the .zip file
                os.remove(zip_path)
                print(f"Removed {zip_path}")

if __name__ == "__main__":
    main()
