$ ->

  converter = new Showdown.converter()

  CommentBox = React.createClass
    loadCommentsFromServer: ->
      $.ajax
        url: @props.url
        dataType: 'json'
      .done (data) =>
        @setState(data: data)
      .fail (xhr, status, err) =>
        console.error @props.url, status, err.toString()

    handleCommentSubmit: (comment) ->
      # Render view first before ajax finish.
      comments = @state.data
      newComments = comments.concat([comment])
      @setState(data: newComments)
      $.ajax
        url: @props.url
        dataType: 'json'
        type: 'POST'
        data: comment: comment
      .done (data) =>
        @setState(data: data)
      .fail (xhr, status, err) =>
        console.error @props.url, status, err.toString()

    getInitialState: -> data: []

    componentDidMount: ->
      @loadCommentsFromServer()
      setInterval @loadCommentsFromServer, @props.pollInterval

    render: ->
      `<div className="commentBox panel panel-default">
          <div className="panel-heading">
           <h3>Comments</h3>
         </div>
         <CommentList data={ this.state.data } />
         <div className="panel-body">
           <CommentForm onCommentSubmit={ this.handleCommentSubmit } />
         </div>
       </div>`

  CommentList = React.createClass
    render: ->
      commentNodes = @props.data.map (comment) ->
        `<Comment author={ comment.author }>{ comment.text }</Comment>`
      `<ul className="commentList list-group">{ commentNodes }</ul>`

  CommentForm = React.createClass
    handleSubmit: (e) ->
      e.preventDefault()
      author = @refs.author.getDOMNode().value.trim()
      text = @refs.text.getDOMNode().value.trim()
      return unless text and author
      @props.onCommentSubmit(author: author, text: text)
      @refs.author.getDOMNode().value = ''
      @refs.text.getDOMNode().value = ''

    render: ->
      `<div className="well">
        <form className="commentForm form-horizontal" onSubmit={ this.handleSubmit }>
          <div className="form-group">
            <label className="col-sm-2 control-label">name</label>
            <div className="col-sm-10">
              <input type="text" className="form-control" placeholder="Your name" ref="author" />
            </div>
         </div>
          <div className="form-group">
            <label className="col-sm-2 control-label">comment</label>
            <div className="col-sm-10">
              <textarea type="text" className="form-control" placeholder="Say something..." ref="text" />
           </div>
         </div>
          <div className="form-group">
            <div className="col-sm-offset-2 col-sm-10">
              <button type="submit" className="btn btn-primary">Post</button>
            </div>
         </div>
         </form>
       </div>`

  Comment = React.createClass
    render: ->
      rawMarkup = converter.makeHtml(@props.children.toString())
      `<li className="comment list-group-item">
         <h4 className="commentAuthor list-group-item-heading">{ this.props.author }</h4>
         <p dangerouslySetInnerHTML={ { __html: rawMarkup } }></p>
       </li>`

  React.render(
    `<CommentBox url="/api/comments" pollInterval={ 1000 * 60 } />`,
    $('#content')[0]
  )
