$ ->
  do setTopLevelLayout
  do initializeMap
  do setCollapses

setTopLevelLayout = ->
  lite = 
    resizable: false
    slidable: false
    closable: false
    spacing_open: false
  $("body").layout {defaults: lite}
  $("#app_page").layout {north: lite}

initializeMap = ->
  map = new OpenLayers.Map("open_layers_map")
  ol_wms = new OpenLayers.Layer.WMS("OpenLayers WMS", "http://vmap0.tiles.osgeo.org/wms/vmap0", {layers: "basic"})
  map.addLayers([ol_wms])
  map.zoomToMaxExtent()

setCollapses = ->
  $(".collapse").each (index, element) ->
    $(element).on "show", ->
      $(element).siblings("h3").addClass "ui-corner-top"
      $(element).siblings("h3").removeClass "ui-corner-all"
    $(element).on "hidden", ->
      $(element).siblings("h3").addClass "ui-corner-all"
      $(element).siblings("h3").removeClass "ui-corner-top"


