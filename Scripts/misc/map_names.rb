=begin
Usage:

Get map name with:

map_name = getmapname("map")

and set it with this:

setmapname("map", "Best map")

and see if it's set with this:

if ismapset?("map")
  # map name is set
else
  # map name isnt set, getting map's name will return it's own name
end

=end

$PLACES = [
# set these in a fashion like this:
  ["Map", "name"],
  ["Map2", "name2"],
# with no comma on the last one
  ["DEBUG", "Debugging grouds"]
]

def getmapname(m)
  $PLACES.each do |place|
    if m == place[0]
      return place[1]
    end
  end
  return m
end

def setmapname(m, newname)
  $PLACES.each_index do |place|
    if m == $PLACES[place][0]
      $PLACES[place][1] = newname
      return
    end
  end
  $PLACES.push([m, newname])
end

def mapnameset?(m)
  $PLACES.each do |place|
    if m == place[0]
      return true
    end
  end
  return false
end
