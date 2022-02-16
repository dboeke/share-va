import turbot
import click
from sgqlc.endpoint.http import HTTPEndpoint
import subprocess
import os
import time

@click.command()
@click.option('-p', '--profile', default="default", help="[String] Profile to be used from config file.")
@click.option('-o', '--output-dir', default=".", help="Path to download folder", type=click.Path(exists=True, file_okay=False))
@click.option('-c', '--cooldown', default=300, help="[Integer] Seconds to wait between mod updates. Default == 5m", type=int)
@click.option('--download/--skip-download', default=True )


def update_mods(profile, output_dir, cooldown, download):
    config_file = None

    config = turbot.Config(config_file, profile)
    headers = {'Authorization': 'Basic {}'.format(config.auth_token)}
    endpoint = HTTPEndpoint(config.graphql_endpoint, base_headers=headers, timeout=240)

    query = '''
        query MyQuery {
            installed: resources(filter: "resourceTypeId:tmod:@turbot/turbot#/resource/types/mod resourceTypeLevel:self limit:1000") {
                mods: items {
                    id: title
                }
            }
        }
    '''

    modlist = {}
    print("Finding installed mods")

    variables = {}
    result = endpoint(query, variables)

    if "errors" in result:
        for error in result['errors']:
            print(error)
        exit()
            
    for mod in result['data']['installed']['mods']:
        sep = "" if output_dir.endswith("/") else "/"
        if download:
            file_name = mod['id'].replace("@", "").replace("/","_")
            download_cmd = f"turbot download {mod['id']} --output {output_dir}{sep}{file_name}.zip"
            print(f"Downloading {mod['id']}")
            subprocess.run(download_cmd, shell=True)
        upload_cmd = f"turbot up --zip-file {output_dir}{sep}{file_name}.zip"
        print(f"Installing {mod['id']}")
        subprocess.run(upload_cmd, shell=True)

        print("Pausing for {} seconds".format(cooldown))
        time.sleep(cooldown)

if __name__ == "__main__":
    update_mods()