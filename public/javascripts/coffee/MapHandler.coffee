PORTAL.prepareMap = ->
  do createProjections
  do createMapEventListeners
  do createMap
  do createLayersSwitcher

PORTAL.finishMap = ->
  if $('#open_layers_map').length #when there is no map DOM object we can't do OpenLayers.LonLat
    PORTAL.map.setCenter(
      new OpenLayers.LonLat(PORTAL.configurationSettings.mapInitialX, PORTAL.configurationSettings.mapInitialY),
      PORTAL.configurationSettings.mapInitialZ
    )
  PORTAL.Utils.sortLayers()

###########################################################

createProjections = ->
  Proj4js.defs["EPSG:2177"] = "+proj=tmerc +lat_0=0 +lon_0=18 +k=0.999923 +x_0=6500000 +y_0=0 +ellps=GRS80 +units=m +no_defs"
  Proj4js.defs['EPSG:2180'] = "+proj=tmerc +lat_0=0 +lon_0=19 +k=0.9993 +x_0=500000 +y_0=-5300000 +ellps=GRS80 +units=m +no_defs"
  PORTAL.epsg2177 = new OpenLayers.Projection("EPSG:2177");
  PORTAL.epsg2180 = new OpenLayers.Projection("EPSG:2180");
  PORTAL.epsg4326 = new OpenLayers.Projection("EPSG:4326");

###########################################################

createMapEventListeners = ->
  PORTAL.zoomIn = new OpenLayers.Control.ZoomBox {active: false}
  PORTAL.zoomOut = new OpenLayers.Control.ZoomBox {active: false, out: true}
  PORTAL.mapEventListeners = {
    zoomend: (event) ->
      PORTAL.zoomIn.deactivate()
      PORTAL.zoomOut.deactivate()
      $("#open_layers_button_zoom_in, #open_layers_button_zoom_out").removeClass "active"
  }

###########################################################

createMap = ->
  PORTAL.map = new OpenLayers.Map "open_layers_map", {
    controls: [],
    eventListeners: PORTAL.mapEventListeners
    allOverlays: true,
    units: "m",
    projection: PORTAL.epsg2180,
    displayProjection: PORTAL.epsg4326,
    maxExtent: new OpenLayers.Bounds(
      PORTAL.configurationSettings.mapBoundingLeft,
      PORTAL.configurationSettings.mapBoundingBottom,
      PORTAL.configurationSettings.mapBoundingRight,
      PORTAL.configurationSettings.mapBoundingTop
    ),
    resolutions: PORTAL.configurationSettings.mapResolutions
  }

###########################################################

createLayersSwitcher = ->
  do disableTextSelection
  do activateTreeComponent
  do activateLayersSelection
  do activateLayersSort
  do activateLayersDetails
  do addLayersToMap

disableTextSelection = -> $("#app_layers .well").disableSelection()

activateTreeComponent = -> $("#app_layers h3, #app_layers h4, #app_layers i.icon-plus, #app_layers i.icon-minus").click -> PORTAL.Handlers.treeClick $(this)

activateLayersSelection = ->
  $("#app_layers .layer-toggler").change -> PORTAL.Handlers.layerToggled $(this)
  $("#app_layers .wms-toggler").change -> PORTAL.Handlers.wmsToggled $(this)
  $("#app_layers .source-toggler").change -> PORTAL.Handlers.sourceToggled $(this)

activateLayersSort = ->
  PORTAL.Handlers.sort $("#app_layers, .tier1_content, .tier2_content")
  $(".tier1_content").sortable "option", "items", ".tier2"

activateLayersDetails = ->
  $(".tier3_content").children("span.btn").click -> PORTAL.Handlers.layerDetails $(this)
  $(".layer-details i").click -> PORTAL.Handlers.changeLayerOpacity $(this)

addLayersToMap = ->
  PORTAL.Utils.addLayer layer for layer in PORTAL.layers
