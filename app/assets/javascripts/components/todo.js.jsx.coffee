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
    `<div className="panel panel-default">
      <div className="panel-heading">
        <h4>Fluxxor TODO</h4>
     </div>
       <ul className="list-group">
         { Object.keys(todos).map(function(id) {
             return <li className="list-group-item" key={id}><TodoItem todo={todos[id]} /></li>;
           })
         }
       </ul>
       <div className="panel-footer">
         <form onSubmit={this.onSubmitForm} className="form-inline">
           <div className="form-group">
             <input type="text" size="30" className="form-control"
                    placeholder="New Todo"
                    value={this.state.newTodoText}
                    onChange={this.handleTodoTextChange} />
           </div>
           <button type="submit" className="btn btn-primary" >Add Todo</button>
           <button onClick={this.clearCompletedTodos} className="btn btn-defalut">Clear Completed</button>
         </form>
       </div>
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
