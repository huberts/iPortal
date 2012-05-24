PORTAL.activateMapLocations = ->
  do fillModal
  do activateButtons

fillModal = ->
  addRow location for location in PORTAL.locations

addRow = (location) ->
  row = $("<div/>", {class: location.cssClass})
  button = $("<button/>", {type: "button", class: "btn btn-mini btn-primary", value: ""+location.coordinateX+"|"+location.coordinateY+"|"+location.zoomLevel})
  iconRight = $("<i/>", {class: "icon-arrow-right icon-white"})
  display = $("<span/>", {html: location.displayName})
  $("#goToLocation .modal-body").append row.append(button.append(iconRight), display)

activateButtons = ->
  $("#goToLocation button").click ->
    coordinates = $(this).val().split "|"
    do hideModal
    PORTAL.map.setCenter new OpenLayers.LonLat(coordinates[1], coordinates[0]), coordinates[2]
  $("#goToLocation a").click hideModal

hideModal = -> $("#goToLocation").modal "hide"
