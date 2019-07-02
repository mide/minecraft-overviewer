#!/usr/bin/python3

import argparse
import json
import urllib.request

MANIFEST_URL = "https://launchermeta.mojang.com/mc/game/version_manifest.json"


def get_json_from_url(url):
    if not url.startswith("https://"):
        raise RuntimeError("Expected URL to start with https://. It is '{}'.".format(url))
    request = urllib.request.Request(url)
    response = urllib.request.urlopen(request)
    return json.loads(response.read().decode())


def get_minecraft_download_url(version):
    data = get_json_from_url(MANIFEST_URL)

    desired_versions = list(filter(lambda v: v['id'] == version, data['versions']))
    if len(desired_versions) == 0:
        raise RuntimeError("Couldn't find Minecraft Version {} in manifest file {}.".format(version, MANIFEST_URL))
    elif len(desired_versions) > 1:
        raise RuntimeError("Found more than one record published for version {} in manifest file {}.".format(version, MANIFEST_URL))

    version_manifest_url = desired_versions[0]['url']
    data = get_json_from_url(version_manifest_url)

    download_url = data['downloads']['client']['url']
    return download_url


parser = argparse.ArgumentParser()
parser.add_argument("version")
args = parser.parse_args()

# Print out URL for consumption by another program.
print(get_minecraft_download_url(args.version))
