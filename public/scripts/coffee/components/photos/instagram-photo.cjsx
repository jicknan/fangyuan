React = require 'react'
_ = require 'underscore'
Moment = require 'moment'

Comments = require './comments'

rad = (x) ->
  return x * Math.PI / 180

# http://stackoverflow.com/questions/1502590/calculate-distance-between-two-points-in-google-maps-v3
distanceBetweenPoints = (p1, p2) ->
	R = 6378137 # Earth’s mean radius in meter
	dLat = rad(p2.latitude - p1.latitude)
	dLong = rad(p2.longitude - p1.longitude)
	a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +

	Math.cos(rad(p1.latitude)) * Math.cos(rad(p2.latitude)) *
	Math.sin(dLong / 2) * Math.sin(dLong / 2)

	c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
	d = R * c
	return d # returns the distance in meter

InstagramPhoto = React.createClass
	getRelativeTime: (timestamp) ->
		Moment( timestamp * 1000 ).fromNow()
	getLocationStr: ->
		meters = Math.round distanceBetweenPoints(@props.userCoords, @props.location)
		distanceStr = (meters / 1000).toFixed(2) + "km"
		if @props.location.name
			distanceStr += " (#{@props.location.name})"
		return distanceStr
	renderComments: ->
		<Comments comments={ @props.data.comments.data } />
	render: ->
		<div className="mdl-card mdl-shadow--2dp instagram-photo">

			<div className="mdl-card__title user-profile">
				<img className="user-avatar" src={ @props.user.profile_picture } width="48" height="48" />
				<div className="mdl-card__title-text">
					<h5>{ @props.user.full_name } <span className="photo-meta">@{ @props.user.username }</span></h5>
				</div>
			</div>

      <div className="mdl-card__menu photo-meta">
        <span className="mdl-badge float-right" data-badge={ @props.data.likes.count } title={ _.pluck( @props.data.likes.data, 'username').join(', ') }>Likes</span><br />
        <span className="float-right">{ @getRelativeTime @props.data.created_time }</span><br />
        <span className="float-right">{ @getLocationStr() }</span>
      </div>

			<div className="mdl-card__media">
        <a href={ @props.data.link } target="_blank">
          <img className="image" src={ @props.images.standard_resolution.url } alt={ @props.data.caption?.text } />
			  </a>
      </div>

			<div className="mdl-card__actions mdl-card--border">
				{ @props.data.caption?.text }
				{ if @props.data.comments.count then @renderComments() }
			</div>
		</div>

module.exports = InstagramPhoto
