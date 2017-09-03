def playerIcons(poi):
    if poi['id'] == 'Player':
        poi['icon'] = "https://overviewer.org/avatar/%s" % poi['EntityId']
        return "Last known location for %s" % poi['EntityId']

# Only signs with "-- RENDER --" on the last line will be shown
# Otherwise, people can't have secret bases and the render is too busy anyways.
def signFilter(poi):
    if poi['id'] == 'Sign':
        if poi['Text4'] == '-- RENDER --':
            return "\n".join([poi['Text1'], poi['Text2'], poi['Text3'], poi['Text4']])

worlds['minecraft'] = "/home/minecraft/server/world"
outputdir = "/home/minecraft/render/"

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
