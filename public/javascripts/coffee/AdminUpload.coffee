PORTAL.activateAdminUpload = ->
  $("#adminUploadModal").on "show", prepareModal
  $("#adminUploadModal").on "hide", cleanUpModal
  $("#adminUploadModal .modal-footer a").on "click", ->
    $("#adminUploadModal").modal 'hide'
  $("#adminUploadModal form input[type='submit']").on "click", ->
    $("#adminUploadModal .alert").hide 'fast';
    $("#adminUploadModal .spinner").show 'fast'

prepareModal = ->
  $("#adminUploadModal").find(".alert, .spinner").hide()
  $("#adminUploadModal iframe").contents().remove()
  $("#adminUploadModal iframe").attr "src", "about:blank"
  $("#adminUploadModal form input[type='reset']").click()

cleanUpModal = ->
  $("#adminUploadModal form input[type='hidden']").remove()