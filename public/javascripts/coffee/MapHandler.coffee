PORTAL.prepareMap = ->
  do createProjections
  do createMapEventListeners
  do createMap
  do createLayersSwitcher

PORTAL.finishMap = ->
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
  PORTAL.mapEventListeners = {
    zoomend: (event) ->
      PORTAL.zoomIn.deactivate()
      $("#open_layers_button_zoom_in").removeClass "active"
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
  do addLayersToMap

disableTextSelection = -> $("#app_layers .well").disableSelection()

activateTreeComponent = -> $("#app_layers h3, #app_layers h4, #app_layers i.icon-plus, #app_layers i.icon-minus").click -> PORTAL.Handlers.treeClick $(this)

activateLayersSelection = ->
  $("#app_layers .layer-toggler").change -> PORTAL.Handlers.layerToggled $(this)
  $("#app_layers .wms-toggler").change -> PORTAL.Handlers.wmsToggled $(this)
  $("#app_layers .source-toggler").change -> PORTAL.Handlers.sourceToggled $(this)

activateLayersSort = ->
  PORTAL.Handlers.sort $("#app_layers, #app_layers .tier1_content, #app_layers .tier2_content")
  $("#app_layers .tier1_content").sortable "option", "items", ".tier2"

addLayersToMap = ->
  PORTAL.Utils.addLayer layer for layer in PORTAL.Layers.list
