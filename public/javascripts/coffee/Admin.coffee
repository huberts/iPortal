$ ->
  do PORTAL.setTopLevelLayout
  do PORTAL.prepareMap
  do PORTAL.createControllers
  do PORTAL.activateLayers
  do PORTAL.activateMapLocations
  do PORTAL.finishMap
  do PORTAL.admin

PORTAL.admin = ->
  $("#adminAddSourceModal .modal-footer a").click -> adminAddSource()
  $(".source-remove").click -> adminDeleteSource $(this)

adminAddSource = ->
    adminAddSourceModalHide()
    sourceName = $("#adminAddSourceModalName").val()

    $.ajax {
      type: "POST",
      url: "admin/addSource",
      data: "name="+sourceName,
      success: (source) ->
        tier1 = $("<div/>", {class: "tier1"})
        tier1Header = $("<div/>", {class: "tier1_header"})
        plus = $("<i/>", {class: "icon-plus icon-white", click: -> PORTAL.Handlers.treeClick $(this)})
        input = $("<input/>", {id: "toggler-" + source.id, type: "checkbox", class: "source-toggler"})
        h3 = $("<h3/>", {html: sourceName, click: -> PORTAL.Handlers.treeClick $(this)})
        pull_right = $("<div/>", {class: "pull-right"})
        remove = $("<i/>", {id: "remove-" + source.id, class: "source-remove icon-white icon-remove", click: -> adminDeleteSource $(this)})

        tier1Content = $("<div/>", {class: "tier1_content well"})
        button = $("<button/>", {html: "Dodaj nową usługę WMS", id: "adminAddWmsButton-" + source.id, class: "btn", type: "button", "data-target": "#addWmsModal", "data-toggle": "modal", "data-id": source.id})
        PORTAL.Handlers.sort tier1Content

        tier1Header.append(plus).append(" ").append(input).append(" ").append(h3).append(pull_right.append(remove))
        tier1Content.append(button)
        tier1.append(tier1Header).append(tier1Content)

        $("#adminAddSourceButton").parent().append tier1
    }

adminAddSourceModalHide = ->
    $("#adminAddSourceModal").modal "hide"

adminDeleteSource = (element)->
    parts = element.attr("id")?.split "-"
    sourceId =  parts[1]
    $.ajax {
      type: "POST",
      url: "admin/deleteSource",
      data: "id="+sourceId,
      success: (data) ->
        element.parent().parent().parent().hide("fast", -> $(this).remove())
    }
