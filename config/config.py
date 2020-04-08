import os


def playerIcons(poi):
    if poi['id'] == 'Player':
        poi['icon'] = "https://overviewer.org/avatar/{}".format(poi['EntityId'])
        return "Last known location for {}".format(poi['EntityId'])


# Only render the signs with the filter string in them. If filter string is
# blank or unset, render all signs. Lines are joined with a configurable string.
def signFilter(poi):
    # Because of how Overviewer reads this file, we must "import os" again here.
    import os
    # Only render signs with this function
    if poi['id'] in ['Sign', 'minecraft:sign']:
        sign_filter = os.environ['RENDER_SIGNS_FILTER']
        hide_filter = os.environ['RENDER_SIGNS_HIDE_FILTER'] == 'true'
        # Transform the lines into an array and strip whitespace from each line.
        lines = list(map(lambda l: l.strip(),[poi['Text1'], poi['Text2'], poi['Text3'], poi['Text4']]))
        # Determine if we should render this sign
        render_all_signs = len(sign_filter) == 0
        render_this_sign = sign_filter in lines
        if render_all_signs or render_this_sign:
            # If the user wants to strip the filter string, we do that here. Only
            # do this if sign_filter isn't blank.
            if hide_filter and not render_all_signs:
                lines = list(filter(lambda l: l != sign_filter, lines))
            return os.environ['RENDER_SIGNS_JOINER'].join(lines)


worlds['minecraft'] = "/home/minecraft/server/world"
outputdir = "/home/minecraft/render/"
texturepath = "/home/minecraft/{}.jar".format(os.environ['MINECRAFT_VERSION'])

markers = [
    dict(name="Players", filterFunction=playerIcons),
    dict(name="Signs", filterFunction=signFilter)
]

renders["day"] = {
    'world': 'minecraft',
    'title': 'Day',
    'rendermode': 'smooth_lighting',
    "dimension": "overworld",
    'markers': markers
}

renders["night"] = {
    'world': 'minecraft',
    'title': 'Night',
    'rendermode': 'smooth_night',
    "dimension": "overworld",
    'markers': markers
}

renders["nether"] = {
    "world": "minecraft",
    "title": "Nether",
    "rendermode": 'nether_smooth_lighting',
    "dimension": "nether",
    'markers': markers
}

renders["end"] = {
    "world": "minecraft",
    "title": "End",
    "rendermode": [Base(), EdgeLines(), SmoothLighting(strength=0.5)],
    "dimension": "end",
    'markers': markers
}

renders["overlay_biome"] = {
    'world': 'minecraft',
    'rendermode': [ClearBase(), BiomeOverlay()],
    'title': "Biome Coloring Overlay",
    "dimension": "overworld",
    'overlay': ["day"]
}

renders["overlay_mobs"] = {
    'world': 'minecraft',
    'rendermode': [ClearBase(), SpawnOverlay()],
    'title': "Mob Spawnable Areas Overlay",
    "dimension": "overworld",
    'overlay': ["day"]
}

renders["overlay_slime"] = {
    'world': 'minecraft',
    'rendermode': [ClearBase(), SlimeOverlay()],
    'title': "Slime Chunk Overlay",
    "dimension": "overworld",
    'overlay': ["day"]
}
