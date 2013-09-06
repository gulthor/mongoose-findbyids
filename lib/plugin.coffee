prequire = require("parent-require")
mongoose = prequire("mongoose")

module.exports = (schema, options) ->
  schema.static("findByIds", (userIds, callback) ->
    # Got an array of ids/users
    if Array.isArray(userIds)
      # Transform array elements to ObjectId
      userIds = userIds.map((user) ->
        if typeof user is "string"
        else
          user = mongoose.Types.ObjectId(user.id)
        return user
      )

      # Build query
      if userIds.length is 1
        query =
          _id: userIds[0]
      else
        query =
          _id:
            $in: userIds
    # Got a single string objectId
    else
      if typeof userIds is "string"
        userIds = mongoose.Types.ObjectId(userIds)
      query =
        _id: userIds

    @find(query).limit(userIds.length).exec((err, users) ->
      if err
        return callback(err)

      if not users
        return callback("No user found with id #{userIds}")

      callback(null, users)
    )
  )
