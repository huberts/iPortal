PORTAL.activateAdminUpload = ->
  $("#adminUploadModal").on "show", prepareModal
  $("#adminUploadModal").on "hide", cleanUpModal
  $("#adminUploadModal .modal-footer a").on "click", ->
    $("#adminUploadModal").modal 'hide'
  $("#adminUploadModal form input[type='submit']").on "click", ->
    $("#adminUploadModal iframe").show 'fast'

prepareModal = ->
  $("#adminUploadModal iframe").hide()
  $("#adminUploadModal iframe").attr "src", "/admin/empty"
  $("#adminUploadModal form input[type='reset']").click()

cleanUpModal = ->
  $("#adminUploadModal form input[type='hidden']").remove()