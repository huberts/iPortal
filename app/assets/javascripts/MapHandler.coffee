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
    allOverlays: true,
    projection: window.epsg2180,
    displayProjection: window.epsg4326,
    maxExtent: new OpenLayers.Bounds(508000, 380000, 525000, 404000)
  }

createLayersSwitcher = ->
  do activateCollapsingWells
  do activateCurrentLayersSection
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


activateCollapsingWells = ->
  $("#wms_all_visible_layers").disableSelection();
  $(".well h3").disableSelection();


activateCurrentLayersSection = ->
  $("#wms_all_visible_layers").sortable();


addLayerToCurrentLayersSection = (layer) ->
  id = buildIdWithPrefix layer.id, "currentLayer"
  html = """
 <div id="#{id}" class="alert alert-info"><a class="close">&times;</a><i class="icon-resize-vertical"></i> #{layer.name}</div>
  """
  $("#wms_all_visible_layers").prepend html
  $("#" + id + " a").click( ->
    $("#" + (buildIdWithPrefix layer.id, "toggler")).button "toggle"
    removeLayerFromCurrentLayersSection layer
  )
  layer.setVisibility true
  if $("#wms_all_visible_layers div").length==1
    $("#wms_all_visible_layers").collapse "show"


removeLayerFromCurrentLayersSection = (layer) ->
  if $("#wms_all_visible_layers div").length==1
    $("#wms_all_visible_layers").collapse "hide"
  id = buildIdWithPrefix layer.id, "currentLayer"
  $('#'+id).remove()
  layer.setVisibility false


activateLayersSelection = ->
  $("button.wms-toggler").click( ->
    $(this).button "toggle"
    if $(this).hasClass "active"
      $(this).siblings("button.layer-toggler").each( (index, element) ->
        if !$(element).hasClass "active"
          $(element).click()
      )
    else
      canDeactivate = true
      $(this).siblings("button.layer-toggler").each( (index, element) ->
        if !$(element).hasClass "active"
          canDeactivate = false
      )
      if canDeactivate
        $(this).siblings("button.layer-toggler").each( (index, element) ->
          $(element).click()
        )
  )


  $("button.layer-toggler").click( ->
    $(this).button "toggle"
    layer = findLayer buildIdWithPrefix $(this).attr("id"), "layer"
    if layer==null
      return
    if $(this).hasClass "active"
      addLayerToCurrentLayersSection layer
    else
      removeLayerFromCurrentLayersSection layer
  )

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
  window.map.zoomToMaxExtent()
