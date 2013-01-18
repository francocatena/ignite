window.IgniteNotes =
  new: (transaction, id)->
    if note = prompt '?'
      os = transaction.objectStore('notes')
      os.add id: id, note: note, date: Date.new

  show: (transaction, id)->
    os = transaction.objectStore('notes')
    request = os.get(id)

    request.onerror = (event)-> alert 'DB Object Store error'
    request.onsuccess = (event)->
      alert request.result.note if request.result
      IgniteNotes.new transaction, id if confirm '¿Crear nota?'

window.IgniteDB =
  start: (db)->
    $(document).keydown (e)->
      key = e.which
      limitNavigation = Slide.limitNavigationQueue.length > 0
      
      if $.inArray(key, [78, 110]) != -1 && !limitNavigation
        dbId = $("#slide-#{Slide.currentNumber()}").data('indexedDbId')
        transaction = db.transaction ['notes'], 'readwrite'

        transaction.oncomplete = (event)-> console.log 'Transaction completed'
        transaction.onerror = (event)-> alert 'DB Transaction error'

        IgniteNotes.show transaction, dbId

jQuery ($)->
  if $('[data-indexed-db-id]').length > 0
    window.indexedDB ||= window.webkitIndexedDB || window.mozIndexedDB
    window.IDBTransaction ||= window.webkitIDBTransaction || window.mozIDBTransaction
    request = window.indexedDB.open 'IgniteNotes', 4 if window.indexedDB
    db = null

    if request
      request.onerror = (event)-> alert "DB error: #{event.target.errorCode}"
      request.onsuccess = (event)->
        IgniteDB.start request.result
      request.onupgradeneeded = (event)->
        console.log 'Actualizando'

        db = event.target.result

        db.createObjectStore 'notes', keyPath: 'id'
