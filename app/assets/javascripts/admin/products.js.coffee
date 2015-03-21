$ ->
  $('body').on 'click', '.select_all', (e) ->
    $('.product.pending > a').trigger('click')

  $('body').on 'click', '.verification .next', (e) ->
    disable = []
    _.each $('.product.pending'), (link) ->
      disable.push( "disable_ids[]=" + $(link).data('id') )
    next_link = $(e.target).attr('href')
    $(e.target).attr('href', next_link + '?' + disable.join('&'))

  $('body').on 'click', '.more', (e) ->
    target_id = $(e.target).data('target')
    $('#'+target_id+' .description').css('height', 'auto')
    $(e.target).remove()
    e.preventDefault()
    return false

  $('[name=new_tag]').on 'keypress submit', (e) ->
    code = e.keyCode || e.which
    if code is 13
      persisted_checkbox = false
      new_tag = $.trim($(e.target).val())

      #check if this tag already used
      _.each $('[type=checkbox]'), (checkbox) ->
        if $(checkbox).val().toLowerCase() is new_tag.toLowerCase()
          $(checkbox).prop('checked', true)
          persisted_checkbox = true

      #skip add new tag if existed
      if !persisted_checkbox
        target_tags_list = $(e.target).data('target')
        new_tag = '<li><label><input name="product['+target_tags_list+'_list][]" type="checkbox" value="'+new_tag+'" checked> '+new_tag+'</label></li>'
        $('#'+target_tags_list + ' ul.edit-tags').prepend(new_tag)
      $(e.target).val('')
      e.preventDefault()
      return false
  $('#tags a:first').tab('show')