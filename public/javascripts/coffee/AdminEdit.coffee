PORTAL.activateAdminEdit = ->
  $("#adminEditModal .modal-footer a").click save
  #$("#adminEditModal").on "show", prepareModal
  $("#adminEditName").on "input", ->
    $("#adminEditName .modal-footer a").attr "disabled", !canSaveEdit()

save = -> doSave() if canSaveEdit()

prepareModal = ->
  id = String($(this).data('modal').options.id)
  parts = id.split "-"
  parts[0] = "toggler"
  $("#adminEditName").val $("#" + parts.join("-")).siblings("h3,h4,label").text()
  $("#adminEditModal .modal-footer a").attr "disabled", !canSaveEdit()

canSaveEdit = -> $("#adminEditName").val().length

doSave = ->
  id = String($("#adminEditModal").data('modal').options.id)
  parts = id.split "-"
  name = $("#adminEditName").val()
  if (parts[0] == "source")
    PORTAL.Admin.editSource(parts[1], name)
  else if (parts[0] == "service")
    PORTAL.Admin.editService(parts[1], parts[2], name)
  else if (parts[0] == "layer")
    PORTAL.Admin.editLayer(parts[1], parts[2], parts[3], name)
  $("#adminEditModal .modal-footer a").attr "disabled", true


hideModal = ->
  $("#adminEditModal").modal "hide"

cleanUpModal = ->
  $("#adminEditModal input").val ""


PORTAL.Admin.editSource = (srcId, name)->
  $.ajax {
    type: "PUT",
    url: "admin/editSource",
    data: {id: srcId, name: name},
    success: (result) ->
      $("#toggler-"+srcId).siblings("h3,h4,label").text name
      hideModal()
  }

PORTAL.Admin.editService = (srcId, wmsId, name)->
  $.ajax {
    type: "PUT",
    url: "admin/editService",
    data: {id: wmsId, name: name},
    success: (result) ->
      $("#toggler-"+srcId+"-"+wmsId).siblings("h3,h4,label").text name
      hideModal()
  }

PORTAL.Admin.editLayer = (srcId, wmsId, layerId, name)->
  $.ajax {
    type: "PUT",
    url: "admin/editLayer",
    data: {id: layerId, name: name},
    success: (result) ->
      $("#toggler-"+srcId+"-"+wmsId+"-"+layerId).siblings("h3,h4,label").text name
      hideModal()
  }