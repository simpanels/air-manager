import os

# This script updates the readme! :)

def generate_readme(directory):
    header = (
        "# Air Manager Panels for Microsoft Flight Simulator 2020 and 2024\n\n"
        "We are a **fork** of [Simstrumentation](https://github.com/Simstrumentation/Air-Manager) as we update and add new instruments for both Microsoft Flight Simulator 2020 as well as 2024.\n\n"
        "We are active on their [Discord](https://discord.gg/6xkCXe5pMn) if you have any questions!\n\n"
        "## Submit your own instruments\n\n"
        "[Click on our Google Form](https://forms.gle/6TeXh5Q3rHtmLRB87) to submit your own instruments.\n\nWe would be VERY happy to see your creations! Our script will automatically create a pull request and update the source code so any changes are seen publically.\n\n"
        "## Important Notes\n\n"
        "Due to numerous issues with MSFS2024, we have all files in a separate folder. We will NOT provide panels which are compatible with both versions from one siff file. You must use the separate siff.\n"
    )
    footer = "\n\n---\n\nREADME automatically generated with ❤️ (see readme.py)."
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
                    raw_instrument_path = instrument_path.replace("blob/", "")
                    # https://raw.githubusercontent.com/simpanels/airmanager/main/msfs2020/airbus_a320_fenix/mcdu/mcdu.siff
                    # https://github.com/cdrage/air-manager/raw/refs/heads/fix-link/msfs2020/airbus_a320_fenix/mcdu/mcdu.siff
                    raw_instrument_link = f"https://github.com/simpanels/air-manager/raw/refs/heads/main/{raw_instrument_path}"
                    instruments.append(f"• [{instrument_name}]({raw_instrument_link})")
        
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

