window.prepareMap = ->
  do createProjections
  do createMap
  do createLayersSwitcher
  do createControllers
  do finish


createProjections = ->
  Proj4js.defs['EPSG:2180'] = '+proj=tmerc +lat_0=0 +lon_0=19 +k=0.9993 +x_0=500000 +y_0=-5300000 +ellps=GRS80 +units=m +no_defs';
  Proj4js.defs["EPSG:2177"] = '+proj=tmerc +lat_0=0 +lon_0=18 +k=0.999923 +x_0=6500000 +y_0=0 +ellps=GRS80 +units=m +no_defs';
  window.epsg2177 = new OpenLayers.Projection('EPSG:2177');
  window.epsg2180 = new OpenLayers.Projection('EPSG:2180');
  window.epsg4326 = new OpenLayers.Projection('EPSG:4326');


createMap = ->
  window.map = new OpenLayers.Map "open_layers_map", {
    controls: [],
    allOverlays: true,
    projection: window.epsg2180,
    displayProjection: window.epsg4326,
    maxExtent: new OpenLayers.Bounds(
      window.configurationSettings.mapBoundingLeft,
      window.configurationSettings.mapBoundingBottom,
      window.configurationSettings.mapBoundingRight,
      window.configurationSettings.mapBoundingTop
    ),
    minScale: window.configurationSettings.mapMinScale,
    maxScale: window.configurationSettings.mapMaxScale,
    numZoomLevels: window.configurationSettings.mapNumZoomLevels,
    units: "m"
  }



createLayersSwitcher = ->
  do disableTextSelection
  do activateIconChanges
  do activateLayersSelection
  addLayer layer for layer in window.layers



addLayer = (layer) ->
  olLayer = new OpenLayers  .Layer.WMS(layer.displayName, layer.serviceUrl,
    {layers: layer.name, transparent: true},
    {visibility: false}
  )
  olLayer.id = "layer-" + layer.index;
  window.map.addLayer olLayer
  if layer.defaultVisible==true
    $("#" + buildIdWithPrefix olLayer.id, "toggler").click()



disableTextSelection = ->
  $("#app_layers .well").disableSelection();



activateIconChanges = ->
  $("#app_layers i").click ->
    if $(this).hasClass "icon-plus"
      $(this).removeClass("icon-plus").addClass("icon-minus")
      $(this).parent().next().show(400)
    else if $(this).hasClass "icon-minus"
      $(this).removeClass("icon-minus").addClass("icon-plus")
      $(this).parent().next().hide(400)



activateLayersSelection = ->

  checkAllLayersFor = (wmsToggler, activated) ->
    allChecked = true
    $(wmsToggler).parent().next(".tier3").find(".layer-toggler").each (i, e) ->
      if $(e).is(":checked")!=activated
        allChecked = false
    return allChecked

  checkAllWMSFor = (sourceToggler, activated) ->
    allChecked = true
    $(sourceToggler).parent().next(".tier2").find(".wms-toggler").each (i, e) ->
      if $(e).is(":checked")!=activated
        allChecked = false
    return allChecked

  $("#app_layers .layer-toggler").change ->
    layer = findLayer buildIdWithPrefix $(this).attr("id"), "layer"
    if layer==null
      return
    layer.setVisibility $(this).is(":checked")
    if checkAllLayersFor $(this).parents(".tier2").find(".wms-toggler"), false
      $(this).parents(".tier2").find(".wms-toggler").attr "checked", false

  $("#app_layers .wms-toggler").change ->
    if $(this).is(":checked")
      $(this).parent().next(".tier3").find(".layer-toggler").each (index, layerToggler) ->
        $(layerToggler).attr "checked", true
        $(layerToggler).change()
    else
      if checkAllLayersFor $(this), true
        $(this).parent().next(".tier3").find(".layer-toggler").each (index, layerToggler) ->
          $(layerToggler).attr "checked", false
          $(layerToggler).change()
    if checkAllWMSFor $(this).parents(".tier1").find(".source-toggler"), false
      $(this).parents(".tier1").find(".source-toggler").attr "checked", false

  $("#app_layers .source-toggler").change ->
    if $(this).is(":checked")
      $(this).parent().next(".tier2").find(".wms-toggler").each (index, wmsToggler) ->
        $(wmsToggler).attr "checked", true
        $(wmsToggler).change()
    else
      if checkAllWMSFor $(this), true
        $(this).parent().next(".tier2").find(".wms-toggler").each (index, wmsToggler) ->
          $(wmsToggler).attr "checked", false
          $(wmsToggler).change()


findLayer = (id) ->
  layers = (layer for layer in window.map.layers when layer.id==id)
  if layers.empty
    return null
  else
    return layers[0]


buildIdWithPrefix = (id, prefix) ->
  parts = id.split "-"
  parts[0] = prefix
  return parts.join "-"


finish = ->
  window.map.setCenter(
    new OpenLayers.LonLat(configurationSettings.mapInitialX, configurationSettings.mapInitialY),
    configurationSettings.mapInitialZ
  )
