@TodoActions =
  addTodo: (text) ->
    @dispatch(todoConstants.ADD_TODO, text: text)

  toggleTodo: (id) ->
    @dispatch(todoConstants.TOGGLE_TODO, id: id)

  clearTodos: ->
    @dispatch(todoConstants.CLEAR_TODOS)
