$ ->
  
  addressInput = $('#address_autocomplete input[type="search"]')
  
  addressInput.autocomplete
    delay: 0
    html: true
    
    source: (request, response) ->
      # console.log "invoked source method"
      $.getJSON "/a/autocomplete?q=#{request.term}", (data) ->
        suggestions = []
        $.each data.response.docs, (i, val) ->
          label = val.address_texts.replace(/\n/, ', ')
          value = label.toString()
          
          if data.highlighting && data.highlighting[val.id].text_hl?
            label = data.highlighting[val.id].text_hl[0].replace(/\n/, ', ')

          suggestions.push(
            label: label,
            value: value
          )

        response suggestions
      
    create: (event, ui) ->
      addressInput.focus()
      # console.log "autocomplete created. event: #{event}, ui: #{ui}"
      
    search: (event, ui) ->
      # console.log "invoked a search"
      
    open: (event, ui) ->
      # console.log "suggestion menu opened"
      
    focus: (event, ui) ->
      # console.log "moving focus to #{ui.item}"
      
    select: (event, ui) ->
      # console.log "selected #{ui.item}"
      
    close: (event, ui) ->
      # console.log "suggestion menu hidden"
      
    change: (event, ui) ->
      # console.log "input field has changed"
      