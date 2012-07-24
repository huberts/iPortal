PORTAL.activateAdminSettings = ->
  do activateInitialMap
  do activateArmsModal
  do activateBoundingBox
  do activateresolutions


activateInitialMap = ->
  $(".initial-showlocation").click ->
    PORTAL.map.setCenter(
      new OpenLayers.LonLat(PORTAL.configurationSettings.mapInitialY, PORTAL.configurationSettings.mapInitialX), PORTAL.configurationSettings.mapInitialZ
    )
  $(".initial-setlocation").click ->
    xCoordinate = PORTAL.map.getCenter().lat.toFixed(0)
    yCoordinate = PORTAL.map.getCenter().lon.toFixed(0)
    zoomLevel = PORTAL.map.getZoom()
    $.ajax {
      type: "PUT",
      url: "admin/changeInitialMap",
      data: {xCoordinate: xCoordinate, yCoordinate: yCoordinate, zoomLevel: zoomLevel},
      success: (result) ->
        PORTAL.configurationSettings.mapInitialX = xCoordinate
        PORTAL.configurationSettings.mapInitialY = yCoordinate
        PORTAL.configurationSettings.mapInitialZ = zoomLevel
    }

activateArmsModal = ->
  $("#adminArmsModal").on "show", prepareArmsModal
  $("#adminArmsModal .modal-footer a").on "click", ->
    $("#adminArmsModal").modal 'hide'
  $("#adminArmsModal form input[type='submit']").on "click", ->
    $("#adminArmsModal .alert").hide 'fast';
    $("#adminArmsModal .spinner").show 'fast'
  $(".arms-set").click ->
    $("#adminArmsModal iframe").off("load").on "load", ->
      if $(this).contents().text().length
        $("#adminArmsModal").find(".spinner, .alert").hide()
        result = $(this).contents().find("img.result")
        if result.length
          $("#adminArmsModal .alert-success").show 'fast'
          PORTAL.configurationSettings.useArms = result.data("arms")
          PORTAL.configurationSettings.appTitle = result.data("title")
          PORTAL.configurationSettings.appLogo = result.attr("src")
          updateArms()
        else
          $("#adminArmsModal .alert-error > span").text $(this).contents().find("title").text()
          $("#adminArmsModal .alert-error").show 'fast'
    $("#adminArmsModal").modal 'show'

updateArms = ->
  if (PORTAL.configurationSettings.useArms)
    $("#app_arms").attr("alt", PORTAL.configurationSettings.appOwner).attr("src", PORTAL.configurationSettings.appLogo)
    $("#app_title").text(PORTAL.configurationSettings.appOwner)
    $("#app_arms").toggle(PORTAL.configurationSettings.useArms)

prepareArmsModal = ->
  $("#adminArmsModal").find(".alert, .spinner").hide()
  $("#adminArmsModal iframe").contents().remove()
  $("#adminArmsModal iframe").attr "src", "about:blank"
  $("#adminArmsModal form input[type='reset']").click()
  $("#adminArmsModal form #armsUse").prop "checked", PORTAL.configurationSettings.useArms
  $("#adminArmsModal form #appTitle").val PORTAL.configurationSettings.appOwner

activateBoundingBox = ->
  $("#adminBBoxModal").on "show", prepareBoundingBoxModal
  $(".boundingbox-set").on "click", ->
    $("#adminBBoxModal").modal 'show'
  $("#adminBBoxModal .modal-footer a").on "click", ->
    $("#adminBBoxModal .modal-footer a").attr "disabled", true
    mapBoundingLeft = parseInt $("#boundingBoxLeft").val()
    mapBoundingTop = parseInt $("#boundingBoxTop").val()
    mapBoundingRight = parseInt $("#boundingBoxRight").val()
    mapBoundingBottom = parseInt $("#boundingBoxBottom").val()
    $.ajax {
      type: "PUT",
      url: "admin/changeBoundingBox",
      data: {mapBoundingLeft: mapBoundingLeft, mapBoundingTop: mapBoundingTop, mapBoundingRight: mapBoundingRight, mapBoundingBottom: mapBoundingBottom},
      success: (result) ->
        PORTAL.configurationSettings.mapBoundingLeft = mapBoundingLeft
        PORTAL.configurationSettings.mapBoundingTop = mapBoundingTop
        PORTAL.configurationSettings.mapBoundingRight = mapBoundingRight
        PORTAL.configurationSettings.mapBoundingBottom = mapBoundingBottom
        PORTAL.map.setOptions {maxExtent: new OpenLayers.Bounds(
          PORTAL.configurationSettings.mapBoundingLeft,
          PORTAL.configurationSettings.mapBoundingBottom,
          PORTAL.configurationSettings.mapBoundingRight,
          PORTAL.configurationSettings.mapBoundingTop
        )}
        $("#adminBBoxModal").modal 'hide'
    }

prepareBoundingBoxModal = ->
  $("#boundingBoxLeft").val PORTAL.configurationSettings.mapBoundingLeft
  $("#boundingBoxTop").val PORTAL.configurationSettings.mapBoundingTop
  $("#boundingBoxRight").val PORTAL.configurationSettings.mapBoundingRight
  $("#boundingBoxBottom").val PORTAL.configurationSettings.mapBoundingBottom
  $("#adminBBoxModal .modal-footer a").attr "disabled", false

activateresolutions = ->
  $(".resolutions-set").on "click", ->
    $("#adminResolutionsModal").modal 'show'
  $("#adminResolutionsModal").on "show", prepareResolutionsModal
  $("#adminResolutionsModal").on "shown", ->
    $("#adminResolutionsModal .modal-footer a").attr "disabled", !validResolutionsString()
  $("#adminResolutionsModal form #resolutions").on "input", ->
    $("#adminResolutionsModal .modal-footer a").attr "disabled", !validResolutionsString()
  $("#adminResolutionsModal .modal-footer a").on "click", ->
    if validResolutionsString
      $.ajax {
        type: "PUT",
        url: "admin/changeResolutions",
        data: {resolutions: $("#adminResolutionsModal form #resolutions").val()},
        success: (result) ->
          PORTAL.map.setOptions {resolutions: result.value}
          $("#adminResolutionsModal").modal 'hide'
      }

prepareResolutionsModal = ->
  $("#adminResolutionsModal form #resolutions").val PORTAL.configurationSettings.mapResolutions.join()

validResolutionsString = ->
  resolutions = $("#adminResolutionsModal form #resolutions").val()
  parts = resolutions.split ","
  valid = true
  $.each(parts, (k, v) ->
    valid = false if !isNumber v
  )
  valid


isNumber = (n) -> parseFloat(n).toString() == n.toString()