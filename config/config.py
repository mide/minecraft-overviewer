#def playerIcons(poi):
#    if poi['id'] == 'Player':
#        poi['icon'] = "http://overviewer.org/avatar/%s" % poi['EntityId']
#        return "Last known location for %s" % poi['EntityId']

worlds['minecraft'] = "/home/minecraft/server/world"
outputdir = "/home/minecraft/render/"

renders["day"] = {
        'world': 'minecraft',
        'title': 'Day',
        'rendermode': 'smooth_lighting'
        #'markers': [dict(name="Players", filterFunction=playerIcons)]
        }

renders["night"] = {
        'world': 'minecraft',
        'title': 'Night',
        'rendermode': 'smooth_night'
       # 'markers': [dict(name="Players", filterFunction=playerIcons)]
        }
