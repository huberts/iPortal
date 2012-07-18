PORTAL.activateAdminAddSource = ->
  $("#adminAddSourceModal .modal-footer a").click -> addSource()
  $("#adminAddSourceModal").on "show", ->
    $("#adminAddSourceModal input").val ""
    $("#adminAddSourceModal .modal-footer a").attr "disabled", !canAddSource()
  $("#adminAddSourceModalName").on "input", ->
    $("#adminAddSourceModal .modal-footer a").attr "disabled", !canAddSource()

addSource = -> doAddSource() if canAddSource()

canAddSource = -> $("#adminAddSourceModalName").val().length

doAddSource = ->
  $("#adminAddSourceModal .modal-footer a").attr "disabled", true
  sourceName = $("#adminAddSourceModalName").val()

  $.ajax {
    type: "POST",
    url: "admin/addSource",
    data: "name="+sourceName,
    success: (response) ->
      $.extend response, {name: sourceName}
      createSourceView response
      PORTAL.tooltips()
  }

createSourceView = (source) ->
  tier1 = $("<div/>", {class: "tier1"})
  tier1Header = $("<div/>", {class: "tier1_header"})
  plus = $("<i/>", {class: "icon-plus icon-white", click: -> PORTAL.Handlers.treeClick $(this)})
  input = $("<input/>", {id: "toggler-" + source.id, type: "checkbox", class: "source-toggler"})
  h3 = $("<h3/>", {html: source.name, click: -> PORTAL.Handlers.treeClick $(this)})
  pull_right = $("<div/>", {class: "pull-right"})
  edit = $("<i/>", {
    class: "source-edit icon-white icon-pencil",
    "data-id" : source.id,
    click: -> PORTAL.Admin.editSource $(this)
  })
  remove = $("<i/>", {
    class: "source-remove icon-white icon-remove",
    "data-id" : source.id,
    click: -> PORTAL.Admin.deleteSource $(this)
  })

  tier1Content = $("<div/>", {class: "tier1_content well"})
  button = $("<button/>", {
    html: "Nowa usługa WMS",
    class: "btn",
    type: "button",
    "data-id": source.id,
    click: -> PORTAL.Layers.addNewWms $(this)})
  PORTAL.Handlers.sort tier1Content

  tier1Header.append(plus).append(" ").append(input).append(" ").append(h3).append(pull_right.append(edit).append(" ").append(remove))
  tier1Content.append(button)
  tier1.append(tier1Header).append(tier1Content)

  $("#adminAddSourceButton").parent().append tier1
  hideModal()

hideModal = ->
  $("#adminAddSourceModal").modal "hide"
