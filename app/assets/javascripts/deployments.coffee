# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# timer identifier
# time in ms
@doneTyping = (element) ->
  value = element.val()
  branch_element = element.closest(".form-group").parent().find(".branch")
  unless value is ""
    $.post "/get_branches",
      repository: value
      type: "get"
    , ((response) ->
      update_branch branch_element, response
      select_master branch_element
      set_branch_name branch_element
      changeSha branch_element
    ), "json"

@update_branch = (branch_element, data) ->
  rows = ""
  for index of data
    rows += "<option value='" + data[index].id + "'>" + data[index].name + "</option>"
  branch_element.html rows

@changeSha = (branch_element) ->
  repository = branch_element.closest(".form-group").parent().find(".repository").val()
  branch_name = branch_element.closest(".form-group").parent().find(".branch option:selected").text()
  sha_element = branch_element.closest(".form-group").parent().find(".sha")
  sha_element.val ""
  if repository isnt "" and branch_name isnt ""
    $.post "/get_sha",
      repository: repository
      branch: branch_name
      type: "get"
    , ((response) ->
      sha_element.val response.sha
    ), "json"

@setDefaultNotify = (env_name, default_channel, default_people) ->
  notify = default_channel.split(",")
  default_people = default_people.split(",")
  input = $('input.notify.typeahead')
  ori_query = input.val().split(",")

  if env_name is 'production'
    notify = notify.concat(default_people)
  else
    for i of default_people
      index = ori_query.indexOf(default_people[i])
      if index > -1
        ori_query.splice index, 1

  for i of notify
    index = ori_query.indexOf(notify[i])
    if index <= -1
      ori_query.push notify[i]

  input.val ori_query.filter((v) ->
    v != ''
  ).join()

@typeahead_matcher = (item) ->
  array = @query.split(",")
  query = array[array.length - 1]
  true unless item.name.toLowerCase().indexOf(query.trim().toLowerCase()) is -1

@select_master = (branch_element) ->
  env_name = $('select.environment option:selected').text()
  if env_name is "production"
    branch_element.find('option').filter(->
      $(this).text() == 'master'
    ).prop 'selected', true

@set_branch_name = (element) ->
  element.closest('.form-group').parent().find('input.branch-name').val element.find('option:selected').text()

#dekstop notification
PNotify::options.styling = 'bootstrap3'
PNotify.desktop.permission()
