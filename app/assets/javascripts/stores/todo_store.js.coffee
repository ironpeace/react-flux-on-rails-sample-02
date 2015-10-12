@TodoStore = Fluxxor.createStore
  initialize: ->
    @todoId = 0
    @todos = {}

    @bindActions(
      todoConstants.ADD_TODO, @onAddTodo
      todoConstants.TOGGLE_TODO, @onToggleTodo,
      todoConstants.CLEAR_TODOS, @onClearTodos
    )

  onAddTodo: (payload) ->
    id = @_nextTodoId()
    todo =
      id: id,
      text: payload.text,
      complete: false
    @todos[id] = todo
    @emit('change')

  onToggleTodo: (payload) ->
    id = payload.id
    todo = @todos[id]
    todo.complete = !todo.complete
    @emit('change')

  onClearTodos: ->
    todos = @todos
    for key, _val of todos
      delete todos[key] if todos[key].complete
    @emit('change')

  getState: -> todos: @todos

  _nextTodoId: -> ++@todoId
