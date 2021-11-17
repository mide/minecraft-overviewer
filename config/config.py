# This config variable is loaded into the upstream Minecraft Overviewer project,
# so it contains undefined variables and some `import` lines.
# flake8: noqa: F821,F401
# pylint: disable=undefined-variable
# type: ignore

import os


def playerIcons(poi):
    if poi["id"] == "Player":
        poi["icon"] = "https://overviewer.org/avatar/{}".format(poi["EntityId"])
        return "Last known location for {}".format(poi["EntityId"])


# Only render the signs with the filter string in them. If filter string is
# blank or unset, render all signs. Lines are joined with a configurable string.
def signFilter(poi):
    # Because of how Overviewer reads this file, we must "import os" again here.
    import os

    # Only render signs with this function
    if poi["id"] in ["Sign", "minecraft:sign"]:
        sign_filter = os.environ["RENDER_SIGNS_FILTER"]
        hide_filter = os.environ["RENDER_SIGNS_HIDE_FILTER"] == "true"
        # Transform the lines into an array and strip whitespace from each line.
        lines = list(
            map(
                lambda l: l.strip(),
                [
                    poi["Text1"],
                    poi["Text2"],
                    poi["Text3"],
                    poi["Text4"],
                ],
            )
        )
        # Remove all leading and trailing empty lines
        while lines and not lines[0]:
            del lines[0]
        while lines and not lines[-1]:
            del lines[-1]
        # Determine if we should render this sign
        render_all_signs = len(sign_filter) == 0
        render_this_sign = sign_filter in lines
        if render_all_signs or render_this_sign:
            # If the user wants to strip the filter string, we do that here. Only
            # do this if sign_filter isn't blank.
            if hide_filter and not render_all_signs:
                lines = list(filter(lambda l: l != sign_filter, lines))
            return os.environ["RENDER_SIGNS_JOINER"].join(lines)


worlds["world"] = os.environ["WORLD_PATH"]
worlds["nether"] = os.environ["NETHER_PATH"]
worlds["end"] = os.environ["END_PATH"]
outputdir = "/home/minecraft/render/"

markers = [
    dict(name="Players", filterFunction=playerIcons),
    dict(name="Signs", filterFunction=signFilter),
]

renders["day"] = {
    "title": "Day",
    "dimension": "overworld",
    "markers": markers,
    "rendermode": "smooth_lighting",
    "world": "world",
}

renders["night"] = {
    "title": "Night",
    "dimension": "overworld",
    "markers": markers,
    "rendermode": "smooth_night",
    "world": "world",
}

renders["nether"] = {
    "title": "Nether",
    "dimension": "nether",
    "markers": markers,
    "rendermode": "nether_smooth_lighting",
    "world": "nether",
}

renders["end"] = {
    "title": "End",
    "dimension": "end",
    "markers": markers,
    "rendermode": [Base(), EdgeLines(), SmoothLighting(strength=0.5)],
    "world": "end",
}

renders["overlay_biome"] = {
    "title": "Biome Coloring Overlay",
    "dimension": "overworld",
    "overlay": ["day"],
    "rendermode": [ClearBase(), BiomeOverlay()],
    "world": "world",
}

renders["overlay_mobs"] = {
    "title": "Mob Spawnable Areas Overlay",
    "dimension": "overworld",
    "overlay": ["day"],
    "rendermode": [ClearBase(), SpawnOverlay()],
    "world": "world",
}

renders["overlay_slime"] = {
    "title": "Slime Chunk Overlay",
    "dimension": "overworld",
    "overlay": ["day"],
    "rendermode": [ClearBase(), SlimeOverlay()],
    "world": "world",
}
