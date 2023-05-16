// Import express
const express = require('express')
const cron = require('node-cron');  

const port = 3000

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
const chargeStationRouter = require('./routes/chargeStation')
const statisticsRouter = require('./routes/statistics')

//Set router as the default router for the app
//app.use('/poc', pocRouter)
app.use('/chargestation', chargeStationRouter);
app.use('/statistics', statisticsRouter)
app.use('/', indexRouter)

//Start the server
app.listen(port, () => console.log(`Webserver listening on port ${port}!`))

//Statistics generation
const aws = require('aws-sdk')
const credentials = new aws.SharedIniFileCredentials({profile: 'default'})
aws.config.credentials = credentials

const ddb = new aws.DynamoDB({region: 'us-east-1'})

async function getStatistics() {

    var puntoscarga_prom = ddb.scan({
        TableName: 'PuntoCarga',
    }).promise()

    var puntoscarga = await Promise.all([puntoscarga_prom])
    puntoscarga = puntoscarga[0].Items;

    var puntostransformados = puntoscarga.map(punto => {
        return {
            id: punto.ID_PuntoCarga.N,
            estado: parseInt(punto.estado.N),
            potencia: punto.cap_carga.N
        }
    })

    var puntoscarga_inactivos = puntostransformados.filter(punto => punto.estado == 0)
    var puntoscarga_activos = puntostransformados.filter(punto => punto.estado == 1)
    var puntocarga_fueraservicio = puntostransformados.filter(punto => punto.estado == 2)

    //Insert result into DynamoDB
    var params = {
        TableName: 'Estadisticas',
        Item: {
            'ID_Estadisticas': {N: parseInt((Date.now()/1000)).toString()},
            'num_pc_nocarga': {N: puntoscarga_inactivos.length.toString()},
            'num_pc_encarga': {N: puntoscarga_activos.length.toString()},
            'num_pc_oos': {N: puntocarga_fueraservicio.length.toString()},
            'puntoscarga_total': {N: puntostransformados.length.toString()},
            'tiempo': {N: parseInt((Date.now()/1000)).toString()}
        }
    }

    ddb.putItem(params, (data) => {
        console.log('Statistics generated successfully')
    })
}

cron.schedule('*/30 * * * * *', () => {
    getStatistics()
}) 