stores =
  TodoStore: new TodoStore()

flux = new Fluxxor.Flux(stores, TodoActions)

FluxMixin = Fluxxor.FluxMixin(React)
StoreWatchMixin = Fluxxor.StoreWatchMixin

TodoItem = React.createClass
  mixins: [FluxMixin]

  propTypes:
    todo: React.PropTypes.object.isRequired

  render: ->
    style =
      textDecoration: if @props.todo.complete then 'line-through' else ''

    `<span style={style} onClick={this.onClick}>{this.props.todo.text}</span>`

  onClick: ->
    @getFlux().actions.toggleTodo(@props.todo.id)


Application = React.createClass
  mixins: [FluxMixin, StoreWatchMixin('TodoStore')]

  getInitialState: ->
    newTodoText: ''

  getStateFromFlux: ->
    flux = @getFlux()
    flux.store('TodoStore').getState()

  render: ->
    todos = @state.todos
    `<div>
       <ul>
         { Object.keys(todos).map(function(id) {
             return <li key={id}><TodoItem todo={todos[id]} /></li>;
           })
         }
       </ul>
       <form onSubmit={this.onSubmitForm}>
         <input type="text" size="30" placeholder="New Todo"
                value={this.state.newTodoText}
                onChange={this.handleTodoTextChange} />
         <input type="submit" value="Add Todo" />
       </form>
       <button onClick={this.clearCompletedTodos}>Clear Completed</button>
     </div>`

  handleTodoTextChange: (e) ->
    @setState(newTodoText: e.target.value)

  onSubmitForm: (e) ->
    e.preventDefault()
    return unless @state.newTodoText.trim()
    @getFlux().actions.addTodo(@state.newTodoText)
    @setState(newTodoText: '')

  clearCompletedTodos: (e) ->
    @getFlux().actions.clearTodos()

document.addEventListener "DOMContentLoaded", (_e) ->
  React.render `<Application flux={flux} />`, document.getElementById('app')
