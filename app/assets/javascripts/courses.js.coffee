# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# jQuery ->
#   $("form").on "click", "form .add_fields", (event) ->
#     position = $("article").length
#     $("article").last().clone().appendTo "section:last"
#     inputTitle = $("article:last input").next('input')
#     inputPicture = $("article:last input")
#     $("article:last label").attr "for", "course_videos_attributes_" + position + "_title"
#     inputTitle.attr "id", "course_videos_attributes_" + position + "_title"
#     inputTitle.attr "name", "course[videos_attributes][" + position + "][title]"
#     inputTitle.attr "placeholder", "Have 100 words to write a title..."
#     inputPicture.attr "id", "course_videos_attributes_" + position + "_picture"
#     inputPicture.attr "name", "course[videos_attributes][" + position + "][picture]"
#     event.preventDefault()

# $(document).on 'click', 'form .add_fields', (event) ->
#     time = new Date().getTime()
#     regexp = new RegExp($(this).data('id'), 'g')
#     $(this).before($(this).data('fields').replace(regexp, time))
#     event.preventDefault()