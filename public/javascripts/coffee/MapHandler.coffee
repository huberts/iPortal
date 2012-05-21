PORTAL.prepareMap = ->
  do createProjections
  do createEventListeners
  do createMap
  do createLayersSwitcher
  do PORTAL.createControllers
  do finish


createProjections = ->
  Proj4js.defs["EPSG:2177"] = '+proj=tmerc +lat_0=0 +lon_0=18 +k=0.999923 +x_0=6500000 +y_0=0 +ellps=GRS80 +units=m +no_defs';
  Proj4js.defs['EPSG:2180'] = '+proj=tmerc +lat_0=0 +lon_0=19 +k=0.9993 +x_0=500000 +y_0=-5300000 +ellps=GRS80 +units=m +no_defs';
  PORTAL.epsg2177 = new OpenLayers.Projection('EPSG:2177');
  PORTAL.epsg2180 = new OpenLayers.Projection('EPSG:2180');
  PORTAL.epsg4326 = new OpenLayers.Projection('EPSG:4326');



createEventListeners = ->
  PORTAL.zoomIn = new OpenLayers.Control.ZoomBox {active: false}
  PORTAL.zoomOut = new OpenLayers.Control.ZoomBox {active: false, out: true}
  PORTAL.mapEventListeners = {
    zoomend: (event) ->
      PORTAL.zoomIn.deactivate()
      PORTAL.zoomOut.deactivate()
      $("#open_layers_button_zoom_in, #open_layers_button_zoom_out").removeClass "active"
  }



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
    minScale: PORTAL.configurationSettings.mapMinScale,
    maxScale: PORTAL.configurationSettings.mapMaxScale,
    numZoomLevels: PORTAL.configurationSettings.mapNumZoomLevels
  }



createLayersSwitcher = ->
  do disableTextSelection
  do activateTreeComponent
  do activateLayersSelection
  do activateLayersSort
  PORTAL.addLayer layer for layer in PORTAL.layers



disableTextSelection = ->
  $("#app_layers .well").disableSelection();



activateTreeComponent = -> $("#app_layers h3, #app_layers h4, #app_layers i").click -> PORTAL.handleTreeClick $(this)

PORTAL.handleTreeClick = (element) ->
  element.parent().siblings().toggle()
  element.parent().children("i.icon-plus, i.icon-minus").toggleClass("icon-plus").toggleClass("icon-minus")



activateLayersSelection = ->

  areAllChecked = (tierContent, togglers, haveToBeChecked) ->
    result = true
    $(tierContent).find(togglers).each (i, e) ->
      if $(e).is(":checked")!=haveToBeChecked
        result = false
    result

  setChecked = (element, tier, togglers, haveToBeChecked, triggerChangeEvent) ->
    $(element).parents(tier).find(togglers).each (i, toggler) ->
      $(toggler).attr "checked", haveToBeChecked
      if triggerChangeEvent
        $(toggler).change()

  areAllWmsActivated = (tier1Content) -> areAllChecked tier1Content, ".wms-toggler", true
  areAllWmsDeactivated = (tier1Content) -> areAllChecked tier1Content, ".wms-toggler", false
  areAllLayersActivated = (tier2Content) -> areAllChecked tier2Content, ".layer-toggler", true
  areAllLayersDeactivated = (tier2Content) -> areAllChecked tier2Content, ".layer-toggler", false


  $("#app_layers .layer-toggler").change ->
    layer = findLayer buildIdWithPrefix $(this).attr("id"), "layer"
    if layer==null
      return
    layer.setVisibility $(this).is(":checked")
    if areAllLayersActivated $(this).parents(".tier2_content")
      setChecked $(this), ".tier2", ".wms-toggler", true, false
    if areAllLayersDeactivated $(this).parents(".tier2_content")
      setChecked $(this), ".tier2", ".wms-toggler", false, false


  $("#app_layers .wms-toggler").change ->
    if $(this).is(":checked")
      setChecked $(this), ".tier2", ".layer-toggler", true, true
    else if areAllLayersActivated $(this).parents(".tier2").children(".tier2_content")
      setChecked $(this), ".tier2", ".layer-toggler", false, true
    if areAllWmsActivated $(this).parents(".tier1_content")
      setChecked $(this), ".tier1", ".source-toggler", true, false
    if areAllWmsDeactivated $(this).parents(".tier1_content")
      setChecked $(this), ".tier1", ".source-toggler", false, false


  $("#app_layers .source-toggler").change ->
    if $(this).is(":checked")
      setChecked $(this), ".tier1", ".wms-toggler", true, true
    else if areAllWmsActivated $(this).parents(".tier1").children(".tier1_content")
      setChecked $(this), ".tier1", ".wms-toggler", false, true



activateLayersSort = ->
  $("#app_layers, .tier1_content, .tier2_content").sortable {cursor: "move", stop: (event, ui) -> PORTAL.sortLayers()}
  $(".tier1_content").sortable "option", "items", ".tier2"



PORTAL.addLayer = (layer) ->
  olLayer = new OpenLayers.Layer.WMS(layer.displayName, layer.serviceUrl,
    {layers: layer.name, transparent: true},
    {visibility: false, singleTile: true, ratio: 1.0, buffer: 1, transitionEffect: "resize"}
  )
  olLayer.id = "layer-" + layer.index;
  PORTAL.map.addLayer olLayer
  if layer.defaultVisible==true
    $("#" + buildIdWithPrefix olLayer.id, "toggler").click()



PORTAL.sortLayers = ->
  $("#app_layers .tier3 input").each (i, e) ->
    PORTAL.map.setLayerIndex findLayer(buildIdWithPrefix($(this).attr("id"), "layer"), i)



findLayer = (id) ->
  layers = (layer for layer in PORTAL.map.layers when layer.id==id)
  if layers.empty
    return null
  else
    return layers[0]



buildIdWithPrefix = (id, prefix) ->
  parts = id.split "-"
  parts[0] = prefix
  parts.join "-"



finish = ->
  PORTAL.map.setCenter(
    new OpenLayers.LonLat(PORTAL.configurationSettings.mapInitialX, PORTAL.configurationSettings.mapInitialY),
    PORTAL.configurationSettings.mapInitialZ
  )
  do PORTAL.sortLayers
