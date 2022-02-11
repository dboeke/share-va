import turbot
import click
from sgqlc.endpoint.http import HTTPEndpoint
import subprocess
import os

@click.command()
@click.option('-p', '--profile', default="default", help="[String] Profile to be used from config file.")
@click.option('-o', '--output-dir', default=".", help="Path to download folder", type=click.Path(exists=True, file_okay=False))
@click.option('--download/--skip-download', default=True )
@click.option('--timeout', default=120, help="[Integer] Seconds to wait for graphql response. Default == 120s", type=float)

def update_mods(profile, output_dir, timeout, download):
    config_file = None

    config = turbot.Config(config_file, profile)
    headers = {'Authorization': 'Basic {}'.format(config.auth_token)}
    endpoint = HTTPEndpoint(config.graphql_endpoint, base_headers=headers, timeout=timeout)

    query = '''
        query Mods($status: [ModVersionStatus!]) {
            latest: modVersionSearches(status: $status) {
                mods: items {
                    name
                    versions {
                        version
                    }
                }
            }
        }
    '''

    modlist = {}
    print("Finding installed mods")

    variables = {'status':["RECOMMENDED"]}
    result = endpoint(query, variables)

    if "errors" in result:
        for error in result['errors']:
            print(error)
        exit()
            
    for mod in result['data']['latest']['mods']:
        sep = "" if output_dir.endswith("/") else "/"
        if download:
            download_cmd = f"turbot download @turbot/{mod['name']} --output {output_dir}{sep}turbot_{mod['name']}.zip"
            subprocess.run(download_cmd, shell=True)
        upload_cmd = f"turbot up --zip-file {output_dir}{sep}turbot_{mod['name']}.zip"
        subprocess.run(upload_cmd, shell=True)

if __name__ == "__main__":
    update_mods()