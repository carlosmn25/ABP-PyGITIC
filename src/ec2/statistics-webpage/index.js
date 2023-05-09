// Import express
const express = require('express')

const port = 80

//Set express to use body-parser as middle-ware.
const app = express()
app.use(express.json())
app.use(express.urlencoded({ extended: false }))

//Set express to use template engine
app.set('views', __dirname + '/views')
app.set('view engine', 'ejs')

app.use(express.static("public"));

//Make a router for the app
const indexRouter = require('./routes/index')
//const pocRouter = require('./routes/poc')
//const chargeStationRouter = require('./routes/chargeStation')
//const statisticsRouter = require('./routes/statistics')



//Set router as the default router for the app
//app.use('/poc', pocRouter)
//app.use('/chargestation', chargeStationRouter);
//app.use('/statistics', statisticsRouter)
app.use('/', indexRouter)

//Start the server
app.listen(port, () => console.log(`Webserver listening on port ${port}!`))