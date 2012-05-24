$ ->
  do PORTAL.setTopLevelLayout
  do PORTAL.prepareMap
  do PORTAL.createControllers
  do PORTAL.activateOwnLayers
  do PORTAL.activateMapLocations
  do PORTAL.finishMap
