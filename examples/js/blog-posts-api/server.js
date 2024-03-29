const express = require("express")
const routes = require("./routes")
const bodyParser = require("body-parser")
const errorhandler = require("errorhandler")

let store = {
  posts: [
    {name: "Top 10 ES6 Features every Web Developer must know",
    url: "https://webapplog.com/es6",
    text: "This essay will give you a quick introduction to ES6. If you don’t know what is ES6, it’s a new JavaScript implementation.",
    comments: [
      {text: "Cruel…..var { house, mouse} = No type optimization at all"},
      {text: "I think you’re undervaluing the benefit of ‘let’ and ‘const’."},
      {text: "(p1,p2)=>{ … } ,i understand this ,thank you !"}
    ]
    },
    {name: "14 Ways Json Can Improve Your SEO",
    url: "https://webapplog.com/es6",
    text: "Best article ever written.",
    comments: [
      {text: "Cruel…..var { house, mouse} = No type optimization at all"},
      {text: "We love to do stuff to help people and stuff"},
      {text: "You can paste your entire post in here"}
    ]
    },
    {name: "search engine optimization",
    url: "https://webapplog.com/es6",
    text: "Very helpful article.",
    comments: [
      {text: "Lorem Ipsum is simply dummy text"},
      {text: "Some more dummy text"}
    ]
    }
  ]
}

let app = express()

app.use(bodyParser.json())
app.use(errorhandler())

app.use((req, res, next) => {
    req.store = store
    next()
})

app.get("/posts", routes.posts.getPosts)
app.post("/posts", routes.posts.addPost)
app.put("/posts/:postId", routes.posts.updatePost)
app.delete("/posts/:postId", routes.posts.removePost)

app.get("/posts/:postId/comments", routes.comments.getComments)
app.post("/posts/:postId/comments", routes.comments.addComment)
app.put("/posts/:postId/comments/:commentId", routes.comments.updateComment)
app.delete("/posts/:postId/comments/:commentId", routes.comments.removeComment)

app.listen(8080)