import os

def generate_readme(directory):
    header = "# Project Documentation\n\nThis repository contains data for various projects.\n\n"
    footer = "\n\n---\n\nGenerated with ❤️."
    msfs_section_header = "## Microsoft Flight Simulator 2020\n\nThis section lists the aircraft and their available instruments.\n\n"
    table_header = "| Name | Image | Instruments |\n|------|-------|-------------|\n"

    msfs_dir = os.path.join(directory, "msfs2020")
    table_rows = []

    for aircraft in sorted(os.listdir(msfs_dir)):
        aircraft_dir = os.path.join(msfs_dir, aircraft)
        if not os.path.isdir(aircraft_dir):
            continue
        
        # Format name
        name = aircraft.replace("_", " ").title()
        
        # Find image
        image_path = os.path.join(aircraft_dir, "plane.png")
        image_link = f'<a href="./{image_path}"><img src="./{image_path}" width="150px"></a>' if os.path.exists(image_path) else "No Image"
        
        # Find instruments
        instruments = []
        for root, _, files in os.walk(aircraft_dir):
            for file in files:
                if file.endswith(".siff"):
                    instrument_name = file.rsplit(".", 1)[0].replace("_", " ").title()
                    instrument_path = os.path.relpath(os.path.join(root, file), directory)
                    instruments.append(f"• [{instrument_name}](./{instrument_path})")
        
        instruments_list = "<br>".join(instruments) if instruments else "No Instruments"
        table_rows.append(f"| {name} | {image_link} | {instruments_list} |")

    table_body = "\n".join(table_rows)
    msfs_section = msfs_section_header + table_header + table_body
    readme_content = header + msfs_section + footer

    with open("README.md", "w") as readme_file:
        readme_file.write(readme_content)

# Directory where your project files are located
project_directory = "."
generate_readme(project_directory)

