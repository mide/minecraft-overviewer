import os


def playerIcons(poi):
    if poi['id'] == 'Player':
        poi['icon'] = "https://overviewer.org/avatar/{}".format(poi['EntityId'])
        return "Last known location for {}".format(poi['EntityId'])


# Only render the signs with the filter string (stored in environment variable
# RENDER_SIGNS_INCLUDE) in them. If RENDER_SIGNS_INCLUDE is blank or unset,
# render all signs. RENDER_SIGNS_INCLUDE defaults to "-- RENDER --" for historic
# reasons, but also so that people can have secret bases and to keep the render
# fairly clean.
def signFilter(poi):
    # Because of how Overviewer reads this file, we must "import os" again here.
    import os
    if poi['id'] in ['Sign', 'minecraft:sign']:
        sign_filter_string = os.environ.get('RENDER_SIGNS_INCLUDE', "")
        render_all_signs = len(sign_filter_string) == 0
        if render_all_signs or sign_filter_string in poi.values():
            return "<br />".join([poi['Text1'], poi['Text2'], poi['Text3'], poi['Text4']])


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
