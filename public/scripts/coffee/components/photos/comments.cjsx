React = require 'react'
_ = require 'underscore'

Comments = React.createClass
	renderComment: (comment) ->
		<div key={ comment.id } className="mdl-card__supporting-text comment">
			<strong>@{ comment.from.username }</strong> { comment.text }
		</div>
	render: ->
		<div>
			{ _.map( @props.comments, @renderComment ) }
		</div>

module.exports = Comments
